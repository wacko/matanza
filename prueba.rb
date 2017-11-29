#!/usr/bin/env ruby
require 'csv'
require_relative 'busqueda'

csv_path = ARGV[0] || './padron.csv'
log_dir = ARGV[1] || './logs'

Persona = Struct.new(:dni, :apellido, :nombre, :tipodoc, :sexo, :localidad)

pami = PamiWebpage.new(log_dir)

begin
  CSV.foreach(csv_path).each.with_index do |row,i|
    begin
      next if i == 0 && row[0] == 'DNI' # skip headers
      persona = Persona.new(*row)
      pami.buscar(persona.dni)

    rescue StandardError => e
      $stderr.puts "Error procesando DNI #{persona.dni} (#{e.class}: #{e})"
      $stderr.puts e.backtrace.first
    end
  end
ensure
  pami.close
end


