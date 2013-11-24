module FreeMart
  class FuzzyRegistry
    include InUse

    def initialize fuzzy_key, provider
      @fuzzy_key = fuzzy_key
      if @fuzzy_key.is_a? Array
        @fuzzy_key.each_index do |i|
          @fuzzy_key[i] = @fuzzy_key[i].to_s if @fuzzy_key.is_a? Symbol
        end
      end

      @provider = provider
    end

    def accept? key
      if @fuzzy_key.is_a? Regexp
        key =~ @fuzzy_key
      elsif @fuzzy_key.is_a? Array
        @fuzzy_key.detect do |item|
          if item.is_a? String
            return true if item == key
          else
            return true if item =~ key
          end
        end
      end
    end

    private

    def process_ key, options, *args
      return NOT_FOUND unless accept? key
      @provider.call options, *args
    end
  end
end

