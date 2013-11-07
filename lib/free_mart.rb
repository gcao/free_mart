require 'free_mart/provider'
require 'free_mart/provider_list'

module FreeMart
  NOT_FOUND = Object.new

  @providers = {}

  def self.register name, value = nil, &block
    provider = if block_given?
                 Provider.new value, &block
               else
                 value
               end

    if @providers.has_key? name
      found = @providers[name]
      if found.is_a? ProviderList
        found << provider
      else
        @providers[name] = ProviderList.new(found, provider)
      end
    else
      @providers[name] = provider
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

  def self.providers
    @providers
  end

  def self.not_found
    NOT_FOUND
  end
end

