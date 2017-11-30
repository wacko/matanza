#!/usr/bin/env ruby
require 'csv'
require 'clap'
require_relative 'busqueda'

csv_path ='./muestra.csv'
log_dir = './logs/thread'
start = 0
thread_count = 4

args = Clap.run ARGV,
  "--log" => lambda { |log| log_dir = log },
  "--start" => lambda { |i| start = i.to_i },
  "--threads" => lambda { |t| thread_count = t.to_i }
csv_path = args.first || './muestra.csv'

puts "Number of Threads: #{thread_count}"
queues = thread_count.times.map{[]}

CSV.foreach(csv_path).each.with_index do |row,i|
  next if i == 0 && row[0] == 'DNI' # skip headers
  next if i < start
  q = i % thread_count
  queues[q].push row.first
end

begin
  pami = PamiWebpage.new(log_dir)
  threads = queues.map.with_index do |queue, thread_id|
    Thread.new(queue, thread_id) {
      queue.each.with_index do |dni,i|
        begin
          pami.buscar(dni)
        rescue StandardError => e
          $stderr.puts "Error procesando DNI #{dni} (#{e.class}: #{e})"
          $stderr.puts e.backtrace.first
        end
      end
    }
  end
  threads.each{|t| t.join}
ensure
  pami.close
end
