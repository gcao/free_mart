require 'set'

module FreeMart
  module InUse
    def process key, options, *args
      in_use_keys << key
      process_ key, options, *args
    ensure
      in_use_keys.delete key
    end

    def processing? key
      in_use_keys.include? key
    end

    private

    def in_use_keys
      @in_use ||= Set.new
    end
  end
end

