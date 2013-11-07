module FreeMart
  class ProviderList < Array
    def initialize *providers
      push *providers
    end

    def call *args
      each do |provider|
        if provider.respond_to? :call
          result = provider.call *args
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

