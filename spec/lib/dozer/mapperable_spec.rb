require 'spec_helper'

RSpec.describe Dozer::Mapperable do
  describe '.mapping' do
    it 'should raise error when from or to argument is missing' do
      class TestMapper
        include ::Dozer::Mapperable
      end

      expect { TestMapper.mapping(from: 'first_name') }.to raise_error(ArgumentError)
      expect { TestMapper.mapping(to: 'first_name') }.to raise_error(ArgumentError)
      expect { TestMapper.mapping(from:'firstName', to: 'first_name') }.not_to raise_error
    end
  end

  describe '.dozer_forward_mapper' do
    it 'should declare a mapper' do
      expect(FooMapper.send(:dozer_forward_mapper)['foo/firstName']).to eq(:first_name)
      expect(FooMapper.send(:dozer_forward_mapper)[:'foo/firstName']).to eq(:first_name)
      expect(FooMapper.send(:dozer_forward_mapper).keys.count).to eq(3)
    end
  end

  describe '.dozer_backward_mapper' do
    it 'should declare a mapper' do
      expect(FooMapper.send(:dozer_backward_mapper)[:first_name]).to eq(:'foo/firstName')
      expect(FooMapper.send(:dozer_backward_mapper)[:last_name]).to eq(:'foo/lastName')
    end
  end

  describe '.transform' do
    context 'keys are hash' do
      it 'should transform a hash from one schema to another schema' do
        hash = { legal_first_name: 'Ryan', legal_last_name: 'Lyu' }
        result = BarMapper.transform(hash)

        expect(result[:first_name]).to eq('Ryan')
        expect(result[:last_name]).to eq('Lyu')
      end

      it 'should ignore the key that are not listed' do
        hash = { 😀: 'Ryan', legal_last_name: 'Lyu' }
        result = BarMapper.transform(hash)

        expect(result[:last_name]).to eq('Lyu')
        expect(result.keys.count).to eq(1)
      end
    end

    context 'keys are string' do
      it 'should transform a hash from one schema to another schema' do
        hash = { 'legal_first_name' => 'Ryan', 'legal_last_name' => 'Lyu' }
        result = BarMapper.transform(hash)

        expect(result[:first_name]).to eq('Ryan')
        expect(result[:last_name]).to eq('Lyu')
      end

      it 'should ignore the key that are not listed' do
        hash = { 'legal_first_name' => 'Ryan', '😀' => 'Lyu' }
        result = BarMapper.transform(hash)

        expect(result[:first_name]).to eq('Ryan')
        expect(result[:last_name]).to be nil
      end
    end

    it 'should transform a hash with symbol key and string key' do
      hash = { 'legal_first_name' => 'Ryan', legal_last_name: 'Lyu' }
      result = BarMapper.transform(hash)

      expect(result[:first_name]).to eq('Ryan')
      expect(result[:last_name]).to eq('Lyu')
    end

    it 'should not return a results that has nil key { nil: 3 }' do
      hash = { a: 1, b: 2, c: 3 }
      result = BarMapper.transform(hash)

      expect(result.keys.include?(nil)).to be false
    end
  end
end
