module FreeMart
  class Provider
    attr_accessor :options, :proxy

    def initialize value, options, &block
      @value   = value
      @options = options
      @block   = block
    end

    def call *args
      if @block
        if @proxy
          @block.call proxy, *args
        else
          @block.call *args
        end
      else
        @value
      end
    end
  end
end

