module Dozer
  module Mapperable
    extend ActiveSupport::Concern

    included do
      attr_accessor :input, :output
    end

    def initialize(input)
      @input = input.with_indifferent_access
      @output = ActiveSupport::HashWithIndifferentAccess.new
    end 

    module ClassMethods

      def mapping(options)
        append_rule(Dozer::Rule.new(options))
      end

      def transform(input,options={})
        instance = self.new(input)
        all_rules.each { |rule| rule.apply!(instance) }
        instance.output
      end

      private

      def append_rule(new_rule)
        if all_rules.any? {|r| r.to == new_rule.to}
          raise ArgumentError, "to: :#{new_rule.to} has been declared."
        end

        all_rules << new_rule
      end


      private def all_rules
        @__all_rules ||= []
      end

    end # end of ClassMethods

  end # end of Mapperable
end # end of Dozer
