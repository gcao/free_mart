module FreeMart
  class FuzzyRegistry
    include InUse

    def initialize fuzzy_key, provider
      @fuzzy_key = fuzzy_key
      @provider = provider
    end

    def accept? key
      if @fuzzy_key.is_a? Regexp
        key =~ @fuzzy_key
      elsif @fuzzy_key.is_a? Array
        @fuzzy_key.include?(key)
      end
    end

    private

    def process_ key, options, *args
      @provider.call options, *args
    end
  end
end

