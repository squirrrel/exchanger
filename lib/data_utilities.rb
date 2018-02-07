class DataGetter
  URL = 'https://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'

  def fetch
    open(URL) rescue '[]'
  end
end

class DataSerializer
  attr_reader :csv_text, :array_of_arrays

  def initialize data:; @csv_text = data; end

  def csv_serialize
    @array_of_arrays = CSV.parse(csv_text)
    @array_of_arrays.shift(5)

    self
  end

  def hashify
    array_of_arrays.map {|a| Hash[ %w{_id unit}.zip(a) ] }
  end
end

class DatabaseGenerator
  attr_reader :serialized_data
  def initialize serialized_data:
    @serialized_data = serialized_data
  end

  def seed_database!
    ExchangeRateTable.create!(serialized_data)
  end
end
