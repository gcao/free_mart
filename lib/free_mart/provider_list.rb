module FreeMart
  class ProviderList < Array
    attr_accessor :options, :proxy

    def initialize key, *providers
      @key = key
      push *providers
    end

    def call *args
      each do |provider|
        if provider.respond_to? :call
          result = if @proxy
                     begin
                       # setup proxy registrar
                       new_providers = FreeMart.providers[@key]
                       FreeMart.providers[@key] = @proxy
                       provider.call *args
                     ensure
                       # restore registrar
                       FreeMart.providers[@key] = new_providers
                     end
                   else
                     provider.call *args
                   end

          if result == NOT_FOUND
            next
          else
            return result
          end
        else
          return provider
        end
      end

      NOT_FOUND
    end
  end
end

