require 'csv'
require 'pp'

csv_path = ARGV[0] || './logs/final/resultados_exitosos.csv'

cr = Hash.new(0)
cp = Hash.new(0)
hr = Hash.new(0)
hp = Hash.new(0)

CSV.foreach(csv_path).each.with_index do |row,i|
  next if i == 0 && row[0] == 'DNI' # skip headers

  cr[row[7]] += 1 # Consultorio Red
  cp[row[8]] += 1 # Consultorio Prestador
  hr[row[9]] += 1 # Hospital Red
  hp[row[10]]+= 1 # Hospital Prestador
end

puts "Consultorio Red"
pp cr

puts "Consultorio Prestador"
pp cp

puts "Hospital Red"
pp hr

puts "Hospital Prestador"
pp hp
