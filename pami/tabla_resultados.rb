class TablaResultados
  include Enumerable

  CANTIDAD_DE_FILAS_INFORMATIVAS = 4 # Fila en blanco, Resultados de la búsqueda, Fila en blanco, Encabezado de la tabla
  attr_reader :dni
  attr_reader :filas

  def initialize dni, page
    @dni = dni
    table = page.css('#fullbody table')[0].children
    @filas = table.slice(CANTIDAD_DE_FILAS_INFORMATIVAS..-1)
  end

  def each
    @filas.each {|fila| yield FilaResultados.new @dni, fila}
  end
end
