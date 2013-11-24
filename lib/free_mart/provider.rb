module FreeMart
  class Provider
    attr_accessor :options
    #attr_accessor :options, :proxy

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
      #if @proxy
      #  begin
      #    # setup proxy registrar
      #    new_providers = FreeMart.providers[@key]
      #    FreeMart.providers[@key] = @proxy
      #    @callback.call *args
      #  ensure
      #    # restore registrar
      #    FreeMart.providers[@key] = new_providers
      #  end
      #else
      #  @callback.call *args
      #end
    end
  end
end

