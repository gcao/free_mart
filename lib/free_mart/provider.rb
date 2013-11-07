module FreeMart
  class Provider
    def initialize value = nil, &block
      @value = value
      @block = block
    end

    def call *args
      if @block
        @block.call *args
      else
        @value
      end
    end
  end
end

