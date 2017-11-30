require 'csv'
require 'httparty'
require 'nokogiri'

require_relative 'pami/fila_resultados'
require_relative 'pami/pagina_resultados'
require_relative 'pami/tabla_resultados'

class PamiWebpage
  include HTTParty
  base_uri 'institucional.pami.org.ar'

  def initialize(log_dir = '.')
    @total = 0
    puts "Log dir: #{log_dir}"

    # Cantidad de resultados por cada DNI buscado
    @log_dni = File.open("#{log_dir}/dni.log", "a")

    # Listados de TODAS las filas de la tabla de busqueda
    # dni, nombre, ID beneficio, parentesco, fecha de alta, fecha de baja,
    # Consultorio externo y Hospital de dia para cada Beneficio
    @log_resultados = File.open("#{log_dir}/resultados.log", "a")

    # Idem resultados.log, pero solo aquellos que cumplan:
    # - localidad = San Justo
    # - sin fecha de baja
    @log_resultados_exitosos = File.open("#{log_dir}/resultados_exitosos.log", "a")
 end

  def close
    @log_dni.close
    @log_resultados.close
    @log_resultados_exitosos.close
  end

  def buscar dni
    @total += 1
    puts "#{@total} => #{dni}"
    flush_logs if @total % 1000 == 0

    resultados = buscar_por_dni dni

    log_cantidad_de_resultados dni, resultados
    fichas = resultados.map do |fila|
      beneficio = buscar_beneficio fila
      log_resultado fila, beneficio
      beneficio
    end

    fichas
  end

private

  def log_cantidad_de_resultados dni, filas
    @log_dni.puts "DNI #{dni} = #{filas.count}"
  end

  def log_resultado fila, beneficio
    @log_resultados.puts fila.to_a.concat(beneficio.to_a).join(',')
    if fila.fecha_baja.empty? && beneficio.localidad == 'SAN JUSTO'
      @log_resultados_exitosos.puts fila.to_a.concat(beneficio.to_a).join(',')
    end
  end

  def log_beneficio fila
    @log_resultados.puts fila
  end

  def parse html
    Nokogiri::HTML(html, nil, Encoding::ISO_8859_1.to_s) do |config|
      config.options =  Nokogiri::XML::ParseOptions::NONET |
                        Nokogiri::XML::ParseOptions::NOERROR |
                        Nokogiri::XML::ParseOptions::NOBLANKS
    end
  end

  def buscar_por_dni dni
    params = { tipoDocumento: 'DNI', nroDocumento: dni, submit2: 'Buscar' }
    page = parse self.class.post('/result.php?c=6-2-2', body: params)
    TablaResultados.new dni, page
  end

  def buscar_beneficio beneficio
    page = parse self.class.get('/' + beneficio.link_detalle)
    PaginaResultados.new beneficio.dni, page
  end

  def flush_logs
    @log_dni.flush
    @log_resultados.flush
    @log_resultados_exitosos.flush
  end
end

