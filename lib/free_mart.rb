require 'free_mart/provider'

module FreeMart
  #NOT_FOUND = Object.new

  @providers = {}

  def self.register name, value = nil, &block
    if block_given?
      @providers[name] = Provider.new value, &block
    else
      @providers[name] = value
    end
  end

  def self.request name, *args
    raise unless @providers.has_key? name

    provider = @providers[name]
    if provider.respond_to? :call
      provider.call *args
    else
      provider
    end
  end

  def self.clear
    @providers.clear
  end
end

