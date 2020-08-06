module Dozer
  class Rule
    attr_accessor :base_klass, :from, :to, :func

    def initialize(options)
      options = options.with_indifferent_access
      validate!(options)

      @base_klass = options[:base_klass]
      @from = options[:from].to_sym
      @to   = options[:to].to_sym
      @func = options[:func]
    end

    def apply(input)
      if applicable?(input)
        [to, evaluate(input[from])]
      else
        nil
      end
    end

    private

    def applicable?(input)
      input.key?(from)
    end

    def evaluate(value)
      return value if func.nil?
      return func.call(value) if func.is_a?(Proc)
      return base_klass.new.send(func, value) if func.is_a?(Symbol)
      nil
    end

    def validate!(options)
      raise ArgumentError, 'from is missing.' if options[:from].nil?
      raise ArgumentError, 'to is missing.' if options[:to].nil?
      if !(options[:func].nil? || options[:func].is_a?(Symbol) || options[:func].is_a?(Proc))
        raise ArgumentError, 'func should be a symbol or proc.'
      end
      true
    end

  end # end of Rule
end # end of Dozer
