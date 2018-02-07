require 'spec_helper'

describe DataGetter do
  describe '#fetch' do
    let(:url) { DataGetter::URL }
    subject   { DataGetter.new.fetch }
    it { expect { subject }.not_to raise_error }
    it { is_expected.to respond_to(:path)      }
    it { is_expected.to be_a(Tempfile)         }
    it { expect(subject.length).not_to be_zero }
  end
end

describe DataSerializer do
  let(:data_serializer)     { DataSerializer.new(data: DataGetter.new.fetch) }
  let(:csv_serialized_data) { data_serializer.csv_serialize                  }
  let(:hashified_csv_data)  { csv_serialized_data.hashify                    }

  describe '#csv_serialize' do
    subject { csv_serialized_data.array_of_arrays }
    it { is_expected.not_to be_empty        }
    it { is_expected.to respond_to(:join)   }
    it { expect(subject[0].length).to eq(2) }
  end

  describe '#hashify' do
    subject { hashified_csv_data[0].with_indifferent_access }
    it { expect(subject).to respond_to(:keys) }
    it { expect(subject[:_id]).not_to be_nil  }
    it { expect(subject[:unit]).not_to be_nil }
  end
end

describe DatabaseGenerator do
  describe '#seed_database!' do
    before(:all) { ExchangeRateTable.delete_all }
    after(:all)  { ExchangeRateTable.delete_all }

    context 'initial state' do
      it { expect(ExchangeRateTable.all().limit(1).first).to be_nil }
    end

    context 'records creation' do
      before(:all) { DatabaseGenerator.new(serialized_data: DataSerializer.new(data: DataGetter.new.fetch ).csv_serialize.hashify ).seed_database! }
      subject(:arbitrary_record) { ExchangeRateTable.all().limit(1).first }
      it { is_expected.not_to be_nil                    }
      it { expect(arbitrary_record._id).to be_a(Date)   }
      it { expect(arbitrary_record.unit).to be_a(Float) }
    end
  end
end
