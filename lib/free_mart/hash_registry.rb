require 'set'

module FreeMart
  class HashRegistry < Hash
    def initialize
      @in_use = Set.new
    end

    def accept? key
      has_key? key
    end

    def process key, options, *args
      @in_use << key
      provider = self[key]
      return NOT_FOUND unless provider
      provider.call options, *args
    ensure
      @in_use.delete key
    end

    def processing? key
      @in_use.include? key
    end
  end
end

