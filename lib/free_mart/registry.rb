module FreeMart
  class Registry < Array
    def add key, provider
      if last and not last.accept? key
        last[key] = provider
      else
        child_registry = HashRegistry.new
        child_registry[key] = provider
        push child_registry
      end
    end

    def accept? key
      detect {|item| item.accept? key }
    end

    def process key, options, *args
      reverse_each do |item|
        next if item.processing? key
        result = item.process key, options, *args
        return result unless result == NOT_FOUND
      end
      NOT_FOUND
    end
  end
end

