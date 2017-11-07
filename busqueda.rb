require 'csv'
require 'httparty'
require 'nokogiri'

require_relative 'pami/fila_resultados'
require_relative 'pami/tabla_resultados'

class PamiWebpage
  include HTTParty
  base_uri 'institucional.pami.org.ar'

  def initialize
    @log_dni = File.open("dni.log", "w")
    @log_resultados = File.open("resultados.log", "w")
  end

  def close
    @log_dni.close
    @log_resultados.close
  end

  def buscar dni
    filas = buscar_por_dni dni

    log_cantidad_de_resultados dni, filas
    filas.each do |fila|
      log_resultado fila
    end

    filas
  end

private

  def log_cantidad_de_resultados dni, filas
    puts dni
    @log_dni.puts "DNI #{dni} = #{filas.size}"
  end

  def log_resultado fila
    @log_resultados.puts "#{fila.dni} #{fila}"
  end

  def parse html
    Nokogiri::HTML(html) do |config|
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
end

