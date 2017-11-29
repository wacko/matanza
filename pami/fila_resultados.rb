class FilaResultados
  attr_reader :dni, :nombre, :beneficio, :parentesco, :fecha_alta, :fecha_baja, :link_detalle

  def initialize dni, row
    # row = Afiliado, Beneficio, Grado Parent, Documento, Fecha Alta, Fecha Baja, Link Detalle
    cells = row.css('td')
    @dni = dni
    @link_detalle = cells.pop.at_css('a')['href']

    datos = cells.map { |cell| cell.text.strip.gsub(/\s\s+/, ' ') }
    @nombre       = datos[0]
    @beneficio    = datos[1]
    @parentesco   = datos[2]
    #documento    = datos[3]
    @fecha_alta   = datos[4]
    @fecha_baja   = datos[5]
    #link_detalle = datos[6]
  end

  def to_a
    [@dni, @nombre, @beneficio, @parentesco, @fecha_alta, @fecha_baja]
  end

  def to_s
    to_a.join(',')
  end
end
