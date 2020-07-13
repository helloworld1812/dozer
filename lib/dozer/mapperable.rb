module Dozer
  module Mapperable
    extend ActiveSupport::Concern

    module ClassMethods
      def mapping(options)
        options = options.with_indifferent_access
        raise ArgumentError, 'from is missing' if options[:from].nil?
        raise ArgumentError, 'to is missing' if options[:to].nil?

        dozer_forward_mapper[options[:from]] = options[:to].to_sym
        dozer_backward_mapper[options[:to]] = options[:from].to_sym
      end

      private def dozer_forward_mapper
        @dozer_forward_mapper ||= {}.with_indifferent_access
      end

      private  def dozer_backward_mapper
        @dozer_backward_mapper ||= {}.with_indifferent_access
      end

      def transform(hash, options={})
        result = {}.with_indifferent_access

        options = options.with_indifferent_access
        mapper = if options[:reverse] == true
                   dozer_backward_mapper
                 else
                   dozer_forward_mapper
                 end

        hash.each do |k, v|
          new_key = mapper[k]
          result[new_key] = v if new_key
        end

        result
      end
    end # end of ClassMethods

  end # end of Mapperable
end # end of Dozer
