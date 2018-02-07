require 'mongoid'

Mongoid.load!('./mongoid.yml', :development)

class ExchangeRateTable
  include Mongoid::Document
  store_in collection: 'ecb', database: 'utilities'

  field :_id,  type: Date
  field :unit, type: Float

  class << self
    def get_in_dates dates:
      find(dates)
    end

    def get_limited_dates_since date:, limit: 1
      where(:_id.gte => date).limit(limit)
    end

    def get_limited_dates_until date:, limit: 1
      result = where(:_id.lte => date)
      result.offset(result.count - limit)
    end
  end
end
