module Dozer
  module Mapperable
    extend ActiveSupport::Concern

    module ClassMethods
      def mapping(options)
        options = options.with_indifferent_access
        dozer_forward_mapper[options[:from]] = options[:to]
        dozer_backward_mapper[options[:to]] = options[:from]
      end

      private def dozer_forward_mapper
        @dozer_forward_mapper ||= {}.with_indifferent_access
      end

      private  def dozer_backward_mapper
        @dozer_backward_mapper ||= {}.with_indifferent_access
      end

      def call(hash, options)
        ret = {}.with_in_different_access

        options = options.with_indifferent_access
        mapper = if options[:direction] == :reverse
                   dozer_backward_mapper
                 else
                   dozer_forward_mapper
                 end

        hash.each do |k, v|
          new_key = mapper[k]
          ret[new_key] = v
        end
      end
    end # end of ClassMethods

  end # end of Mapperable
end # end of Dozer
