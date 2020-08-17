require 'spec_helper'
require 'date'

RSpec.describe Dozer::Rule do
  describe '#initialize' do
    it 'should succeed' do
      expect { Dozer::Rule.new(from: :firstName, to: :first_name) }.not_to raise_error
      expect { Dozer::Rule.new(from: 'firstName', to: 'first_name') }.not_to raise_error
      expect { Dozer::Rule.new('from' => 'firstName', 'to' => 'first_name') }.not_to raise_error
      expect { Dozer::Rule.new('from' => :firstName, 'to' => :first_name) }.not_to raise_error
      expect { Dozer::Rule.new(from: :firstName, to: :first_name, func: ->(val) { val.to_s }) }.not_to raise_error
      expect { Dozer::Rule.new(from: :firstName, to: :first_name, func: :some_function) }.not_to raise_error
    end

    it 'should raise error' do
      expect { Dozer::Rule.new(from: :firstName) }.to raise_error(ArgumentError)
      expect { Dozer::Rule.new(to: :first_name) }.to raise_error(ArgumentError)
      expect { Dozer::Rule.new(from: :firstName, to: :first_name, func: "something") }.to raise_error(ArgumentError)
    end
  end

  describe '#applicable?' do
    it 'should be not applicable?' do
      rule = Dozer::Rule.new(from: :firstName, to: :first_name)
      input = {age: 32}
      expect(rule.send(:applicable?, input)).to be false
    end

    it 'should be applicable?' do
      rule = Dozer::Rule.new(from: :firstName, to: :first_name)
      input = {firstName: 'Ryan'}
      expect(rule.send(:applicable?, input)).to be true
    end
  end

  # describe '#evaluate' do
  #   it 'should call a proc to convert a datetime to date' do
  #     started_at = DateTime.parse('2020-08-06 11:37:25')
  #     rule = Dozer::Rule.new(from: :started_at, to: :start_on, func: ->(datetime) { datetime.to_date.to_s })
  #     started_on = rule.send(:evaluate, started_at)
  #     expect(started_on).to eq('2020-08-06')
  #   end

  #   it 'should call a method to convert an string to string' do
  #     class TestMapperWithMethod
  #       include ::Dozer::Mapperable

  #       def status_to_boolean(val)
  #         case val
  #         when 'true'
  #           true
  #         when 'false'
  #           false
  #         end
  #       end
  #     end

  #     rule = Dozer::Rule.new(from: :status, to: :status, func: :status_to_boolean, base_klass: TestMapperWithMethod)
  #     expect(rule.send(:evaluate, 'true')).to be true
  #     expect(rule.send(:evaluate, 'false')).to be false
  #   end
  # end
end
