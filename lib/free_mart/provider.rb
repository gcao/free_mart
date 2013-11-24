module FreeMart
  class Provider
    attr_accessor :options

    def initialize key, value, options, &block
      @key      = key
      @options  = options
      @callback = if block_given?
                    block
                  else
                    value
                  end
    end

    def call *args
      @callback.call *args
    end
  end
end

