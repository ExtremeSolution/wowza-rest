require 'spec_helper'
require 'rspec/json_expectations'

RSpec.describe WowzaRest::Data::Base do
  subject(:base) { described_class.new }

  describe '#wrap_array_objects' do
    context 'when array is empty' do
      it 'returns an empty array' do
        expect(base.wrap_array_objects([], Struct)).to eq([])
      end
    end
    context 'when array is nil' do
      it 'returns nil' do
        expect(base.wrap_array_objects(nil, Struct)).to be_nil
      end
    end
    context 'when array contains values' do
      let(:values) do
        [{ 'attr' => 'value' }]
      end

      let(:mapped) do
        base.wrap_array_objects(values, described_class)
      end

      it 'returns an array' do
        expect(mapped).to be_an(Array)
      end

      it 'contains an instance of given class' do
        expect(mapped.first).to be_instance_of(described_class)
      end
    end
  end

  describe '#objects_array_to_hash_array' do
    context 'when given array is nil' do
      it 'returns nil' do
        expect(base.objects_array_to_hash_array(nil)).to be_nil
      end
    end
    context 'when given array is empty' do
      it 'returns empty array' do
        expect(base.objects_array_to_hash_array([])).to eq([])
      end
    end
    context 'when array contains WowzaRest::Data::Base or its childs' do
      let(:values) do
        [described_class.new('attr' => 'value')]
      end

      let(:mapped) do
        base.objects_array_to_hash_array(values)
      end

      it 'returns a hash version of it' do
        expect(mapped.first).to be_a(Hash)
      end
    end
    context 'when array object is a normal hash object' do
      let(:values) do
        [{ 'attr' => 'value' }]
      end

      let(:mapped) do
        base.objects_array_to_hash_array(values)
      end

      it 'returns it as is' do
        expect(mapped.first).to be_a(Hash)
      end
    end
  end

  describe '#to_h' do
    subject(:base) do
      described_class.new(values)
    end

    let(:values) do
      { 'appType' => 'name', 'theIP' => '0.0.0.0' }
    end

    it 'returns hash version' do
      expect(base.to_h).to eq(values)
    end
  end

  describe '#to_json' do
    subject(:base) do
      described_class.new(values)
    end

    let(:values) do
      { name: 'name', appType: 'type' }
    end

    it 'returns json format' do
      expect(base.to_json).to include_json(values)
    end
  end
  describe '#include?' do
    subject(:base) do
      described_class.new(name: 'name')
    end

    context 'when it has instance variable with the same name' do
      it 'returns true' do
        expect(base.include?(:name)).to be true
      end
    end

    context 'when it given name dont match with any instance variables' do
      it 'returns false' do
        expect(base.include?(:not_existed_name)).to be false
      end
    end
  end
end
