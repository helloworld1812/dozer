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

  describe '.mapping' do
    it 'should call append_rule' do
      mapper = Class.new
      mapper.send(:include, ::Dozer::Mapperable)
      expect(mapper).to receive(:append_rule)
      mapper.mapping from: :first_name, to: :firstName
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
        hash = { 'legal_first_name' => 'Ryan', 'legal_last_name' => 'Lyu', 'legal_m' => 'D' }
        result = BarMapper.transform(hash)

        expect(result[:first_name]).to eq('Ryan')
        expect(result[:last_name]).to eq('Lyu')
        expect(result[:middle_name]).to eq('D')
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

    it 'should convert data through proc' do
      input = { gender: :male }
      result = AdpMapper.transform(input)
      expect(result.keys.include?('/applicant/person/genderCode/codeValue')).to be true
      expect(result['/applicant/person/genderCode/codeValue']).to eq('M')
    end

    it 'should convert data through custom method' do
      input = { marital_status: 'married' }
      result = AdpMapper.transform(input)
      expect(result.keys.include?('/applicant/person/maritalStatusCode/codeValue')).to be true
      expect(result['/applicant/person/maritalStatusCode/codeValue']).to eq('1')
    end
  end

  describe '.all_rules' do
    it 'should have eight rules' do
      mapper = Class.new
      mapper.send(:include, ::Dozer::Mapperable)
      mapper.mapping(from: :firstName, to: :first_name)
      mapper.mapping(from: :lastName, to: :last_name)
      expect(mapper.send(:all_rules).count).to eq(2)
    end

    it 'should declare an instance variable' do
      mapper = Class.new
      mapper.send(:include, ::Dozer::Mapperable)
      expect(mapper.instance_variable_defined?("@__all_rules")).to be false
      mapper.mapping(from: :first_name, to: :firstName)
      expect(mapper.instance_variable_defined?("@__all_rules")).to be true
    end
  end

  describe '.append_rule' do
    it 'should successfully append new rule' do
      mapper = Class.new
      mapper.send(:include, ::Dozer::Mapperable)
      rule = Dozer::Rule.new(from: :firstName, to: :first_name, base_klass: mapper)
      expect(mapper.send(:all_rules).count).to eq(0)
      mapper.send(:append_rule, rule)
      expect(mapper.send(:all_rules).count).to eq(1)
    end

    it 'should raise error when add a new rule with same `to` attribute' do
      mapper = Class.new
      mapper.send(:include, ::Dozer::Mapperable)
      mapper.mapping(from: :first_name, to: :firstName)
      expect { mapper.mapping(from: 'firstname', to: :firstName) }.to raise_error(ArgumentError)
    end
  end
  
end # Rspec
