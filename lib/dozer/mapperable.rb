module Dozer
  module Mapperable
    extend ActiveSupport::Concern

    module ClassMethods
      def mapping(options)
        rule = Dozer::Rule.new(options.merge(base_klass: self))
        append_rule(rule)
      end

      def transform(input, options={})
        input, output = input.with_indifferent_access, ActiveSupport::HashWithIndifferentAccess.new
        kvs = all_rules.map { |rule| rule.apply(input) }.compact!
        kvs.each do |kv|
          key, value = kv.first, kv.last
          output[key] = value
        end

        output
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
