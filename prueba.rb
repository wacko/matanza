#!/usr/bin/env ruby
require 'csv'
require_relative 'busqueda'

csv_path = ARGV[0] || './padron.csv'

Persona = Struct.new(:dni, :apellido, :nombre, :tipodoc, :sexo, :localidad)

pami = PamiWebpage.new

begin
  CSV.foreach(csv_path).each.with_index do |row,i|
    begin
      next if i == 0 # skip headers
      persona = Persona.new(*row)
      pami.buscar persona.dni

    rescue StandardError => e
      puts "Error procesando DNI #{persona.dni} (#{e.class}: #{e})"
    end
  end
ensure
  pami.close
end


