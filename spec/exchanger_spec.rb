require 'spec_helper'

describe Exchanger do
  before(:all) do
    unless ExchangeRateTable.all().limit(1).first
      DatabaseGenerator.new(
        serialized_data: DataSerializer.new(
          data: DataGetter.new.fetch
        ).csv_serialize.hashify
      ).seed_database!
    end
  end
  after(:all)  { ExchangeRateTable.delete_all }

  describe '#standard_compute' do
    let(:dates) { ['2018-01-25', '2018-01-24'] }
    let(:exchanger_object) { Exchanger.new(amount: 100, currency: :dollar) }

    subject { exchanger_object.standard_compute(dates) }
    it { expect(subject.result_container.count).to eq(dates.count) }
    it { expect(subject.result_container[dates[0]]).to be_a(Float) }
    it { expect(subject.result_container[dates[0]]).to eq(subject.amount.amount*subject.amount.unit) }

    context 'converts to euro' do
      let(:to_euro_exchanger_object) { Exchanger.new(amount: 100, currency: :euro) }
      subject { to_euro_exchanger_object.standard_compute(dates) }
      it { expect(subject.result_container[dates[0]]).to eq((subject.amount.amount/subject.amount.unit).round(4)) }
    end

    context 'single date' do
      let(:date) { ['2018-01-25'] }
      subject { exchanger_object.standard_compute(date) }
      it { expect(subject.result_container.count).to eq(1) }
      it { expect(subject.result_container[dates[0]]).to be_a(Float) }
    end
  end

  pending '#compute_for_days_since', skip: true

  pending '#compute_for_days_until', skip: true
end
