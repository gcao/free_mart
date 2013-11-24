module FreeMart
  class SimpleProvider
    attr_accessor :options

    def initialize key, value, options
      @key     = key
      @value   = value
      @options = options
    end

    def call *args
      @value
    end
  end
end

