module Dozer
  module Mapperable
    extend ActiveSupport::Concern

    included do
      attr_accessor :input, :output, :options
    end

    def initialize(input,hash)
      @input = input.with_indifferent_access
      @output = ActiveSupport::HashWithIndifferentAccess.new
      @options = hash.with_indifferent_access
    end 

    module ClassMethods

      def mapping(options)
        append_rule(Dozer::Rule.new(options))
      end

      def transform(input,hash={})
        instance = self.new(input,hash)
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
