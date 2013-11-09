require 'free_mart/provider'
require 'free_mart/provider_list'

module FreeMart
  NOT_FOUND = Object.new

  @providers = {}

  def self.register key, *rest, &block
    value, options = handle_args block_given?, *rest

    provider = Provider.new key, value, options, &block

    if @providers.has_key? key
      found = @providers[key]
      if found.is_a? ProviderList
        found << provider
      else
        @providers[key] = ProviderList.new(key, found, provider)
      end
    else
      @providers[key] = provider
    end

    provider
  end

  def self.request key, *args
    raise "No provider is registered for #{key}." unless @providers.has_key? key

    provider = @providers[key]
    result = provider.call *args
    result == NOT_FOUND ? raise("No result is returned.") : result
  end

  def self.requestAll key, *args
    raise 'TODO'
  end

  def self.reregister key, *rest, &block
    value, options = handle_args block_given?, *rest

    provider = Provider.new key, value, options, &block

    if @providers.has_key? key
      found = @providers[key]
      provider.proxy = found
    end

    @providers[key] = provider

    provider
  end

  def self.deregister key, provider
    found = @providers[key]

    if found == provider
      if found.proxy
        @providers[key] = found.proxy
      else
        @providers.delete key
      end
    end
  end

  def self.clear *keys
    if keys.length > 0
      keys.each {|key| @providers.delete key }
    else
      @providers.clear
    end
  end

  def self.providers
    @providers
  end

  def self.not_found
    NOT_FOUND
  end

  private

  def self.handle_args has_block, *args
    if has_block
      value = NOT_FOUND
    else
      value = args.shift
    end
    default_options = {}
    options = default_options.merge args.first if args.first
    [value, options]
  end

end

