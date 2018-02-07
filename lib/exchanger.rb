class Exchanger
  attr_accessor :amount, :currency, :records, :result_container

  def initialize amount:, currency:
    @amount = Amount.new(amount: amount)
    @currency = currency
    @result_container = {}
  end

  def standard_compute dates
    @dates ||= dates
    @records = ExchangeRateTable.get_in_dates(dates: dates)

    generate_results
  end

  # #compute_for_days_since and #compute_for_days_until methods
  %w(since until).each do |since_or_until|
    define_method "compute_for_days_#{since_or_until}" do |date, number_of_days|
      return 'specify a string format single date' if date.respond_to?(:join)
      number_of_days ||= 2
      @records = ExchangeRateTable.send "get_limited_dates_#{since_or_until}", date: date, limit: number_of_days

      @dates = @records.pluck(:_id)

      generate_results

      self
    end
  end

  private

  def generate_results
    records.each {|record| generate_single_result(record) }
    self
  end

  def generate_single_result record
    amount.unit = record.unit
    actual_amount  = amount.send "in_#{currency}"
    @result_container[record._id.to_s] = actual_amount
  end
end

class Amount
  attr_accessor :amount, :unit

  def initialize amount:, unit: nil
    @amount = amount
    @unit = unit
  end

  def in_dollar; (amount*unit); end

  def in_euro; (amount/unit).round(4); end
end
