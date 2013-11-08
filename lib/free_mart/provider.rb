module FreeMart
  class Provider
    attr_accessor :options, :proxy

    def initialize key, value, options, &block
      @key     = key
      @value   = value
      @options = options
      @block   = block
    end

    def call *args
      if @block
        if @proxy
          begin
            # setup proxy registrar
            new_providers = FreeMart.providers[@key]
            FreeMart.providers[@key] = @proxy
            @block.call *args
          ensure
            # restore registrar
            FreeMart.providers[@key] = new_providers
          end
        else
          @block.call *args
        end
      else
        @value
      end
    end
  end
end

