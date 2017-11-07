class FilaResultados
  attr_reader :dni, :datos, :link_detalle

  def initialize dni, row
    # row = Afiliado, Beneficio, Grado Parent, Documento, Fecha Alta, Fecha Baja, Link Detalle
    cells = row.css('td')
    @dni = dni
    @link_detalle = cells.pop.at_css('a')['href']
    @datos = cells.map { |cell| cell.text.strip }
  end

  def to_s
    [@dni, @datos].join(',').gsub(/\s\s+/, ' ')
  end
end
