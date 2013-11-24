module FreeMart
  class Registry < Array
    def add key, provider
      if last.is_a? HashRegistry and not last.accept? key
        last[key] = provider
      else
        if key.is_a? String
          child_registry = HashRegistry.new
          child_registry[key] = provider
        else
          child_registry = FuzzyRegistry.new key, provider
        end
        push child_registry
      end
    end

    def accept? key
      detect {|item| item.accept? key }
    end

    def process key, options, *args
      if options[:all]
        result = []
        each do |item|
          item_result = item.process key, options, *args
          result.push *item_result unless item_result == NOT_FOUND
        end
        result
      else
        reverse_each do |item|
          next if item.processing? key
          result = item.process key, options, *args
          return result unless result == NOT_FOUND
        end
        NOT_FOUND
      end
    end
  end
end

