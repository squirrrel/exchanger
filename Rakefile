require 'csv'
require 'open-uri'
require 'time'
require './lib/exchange_rate_table.rb'
require './lib/data_utilities.rb'
require './lib/exchanger.rb'

task :seed_database do
  DatabaseGenerator.new(
    serialized_data: DataSerializer.new(
      data: DataGetter.new.fetch
    ).csv_serialize.hashify
  ).seed_database!
end

task :regular_exchange_amount, [:amount, :currency, :dates] do |t, args|
  dates = args[:dates].split(' ')
  exchanger = Exchanger.new(amount: args[:amount].to_i, currency: args[:currency])
  exchanger.standard_compute(dates)

  puts exchanger.result_container
end

task :date_offset_exchange_amount, [:amount, :currency, :date, :offset, :since_or_until] do |t, args|
  exchanger = Exchanger.new(amount: args[:amount].to_i, currency: args[:currency])
  exchanger.send "compute_for_days_#{args[:since_or_until]}", args[:date], args[:offset].to_i

  puts exchanger.result_container
end
