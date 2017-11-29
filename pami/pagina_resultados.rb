class PaginaResultados
  attr_reader :dni, :localidad
  attr_reader :prestaciones, :familiares
  attr_reader :consultorio_red, :consultorio_prestador, :hospital_red, :hospital_prestador


  CONSULTORIO_EXTERNO = 'SALUD MENTAL CONSULTORIO EXTERNO'.freeze
  HOSPITAL_DE_DIA = 'SALUD MENTAL HOSPITAL DE DIA'.freeze
  # UGL = Unidad de Gestión Local

  def initialize dni, page
    @dni = dni
    body = page.at_css('#fullbody')

    # Beneficiario Titular
    beneficiario = body.at_css("table[width='480']")
    set_localidad(beneficiario)

    prestaciones, familiares, _ = body.css("table[width='580']")
    set_consultorio prestaciones
    set_hospital prestaciones
    # @consultorio_externo = buscar_prestacion(prestaciones, CONSULTORIO_EXTERNO)
    # @hospital_de_dia = buscar_prestacion(prestaciones, HOSPITAL_DE_DIA)
  end

  def set_localidad table
    fila_ugl = table.css('tr').find{|x| x.at_css('td').text == 'UGL:' }
    @localidad = fila_ugl.css('td').last.text
  end

  def buscar_prestacion table, text
    # Las tablas estan mal formadas. No todos los <td> están dentro de <tr>.
    cells = table.css('td')
    cells.each_with_index do |element, i|
      if element.text == text
        return [cells[i+1].text, cells[i+2].text]
      end
    end
    ['', '']
  end

  def set_consultorio prestaciones
    @consultorio_red, @consultorio_prestador = buscar_prestacion(prestaciones, CONSULTORIO_EXTERNO)
  end
  def set_hospital prestaciones
    @hospital_red, @hospital_prestador = buscar_prestacion(prestaciones, HOSPITAL_DE_DIA)
  end

  def to_a
    [@localidad, @consultorio_red, @consultorio_prestador, @hospital_red, @hospital_prestador]
  end

  def to_s
    to_a.join(',')
  end

end
