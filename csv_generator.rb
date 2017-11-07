#!/usr/bin/env ruby
require 'creek'
require 'csv'

excel_path = ARGV[0] || './padron.xlsx'
csv_path = ARGV[1] || './padron.csv'

creek = creek::Book.new excel_path

row_number = 0
CSV.open(csv_path, "w") do |csv|
  creek.sheets[0].rows.with_index.map do |row, j|
    row_number += 1
    puts row_number if (row_number % 10000 == 0)

    i = j+1
    csv << row.values_at("A#{i}", "C#{i}", "D#{i}", "F#{i}", "J#{i}", "N#{i}")
  end
end
