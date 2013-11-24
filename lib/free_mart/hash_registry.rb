module FreeMart
  class HashRegistry < Hash
    include InUse

    def accept? key
      has_key? key
    end

    private

    def process_ key, options, *args
      provider = self[key]
      return NOT_FOUND unless provider
      provider.call options, *args
    end
  end
end

