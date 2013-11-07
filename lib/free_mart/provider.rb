module FreeMart
  class Provider
    attr_accessor :proxy

    def initialize value = nil, &block
      @value = value
      @block = block
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

