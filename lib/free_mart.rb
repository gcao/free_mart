require 'free_mart/not_found_error'

require 'free_mart/provider'
require 'free_mart/simple_provider'
#require 'free_mart/provider_list'
require 'free_mart/in_use'
require 'free_mart/registry'
require 'free_mart/hash_registry'
require 'free_mart/fuzzy_registry'

module FreeMart
  NOT_FOUND = Object.new

  @registry = Registry.new

  def self.registry
    @registry
  end

  def self.register key, *rest, &block
    key = key.to_s if key.is_a? Symbol

    value, options = handle_args block_given?, *rest

    provider = create_provider key, value, options, &block
    @registry.add key, provider

    #if @registry.has_key? key
    #  found = @registry[key]
    #  if found.is_a? ProviderList
    #    found << provider
    #  else
    #    @registry[key] = ProviderList.new(key, found, provider)
    #  end
    #else
    #  @registry[key] = provider
    #end

    provider
  end

  def self.request key, *args
    key = key.to_s

    result = @registry.process key, {key: key}, *args
    if result == NOT_FOUND
      raise NotFoundError.new(key)
    else
      result
    end
    #provider = @registry[key]

    #if provider
    #  result = provider.call *args
    #  result == NOT_FOUND ? raise("No result is returned.") : result
    #else
    #  raise "No provider is registered for #{key}."
    #end
  end

  #def self.request_no_error key, *args
  #  key = key.to_s

  #  provider = @registry[key]

  #  if provider
  #    provider.call *args
  #  else
  #    NOT_FOUND
  #  end
  #end

  def self.accept? key
    @registry.accept? key.to_s
  end

  #def self.reregister key, *rest, &block
  #  key = key.to_s

  #  value, options = handle_args block_given?, *rest

  #  provider = create_provider key, value, options, &block

  #  if @registry.has_key? key
  #    found = @registry[key]
  #    provider.proxy = found
  #  end

  #  @registry[key] = provider

  #  provider
  #end

  #def self.deregister key, provider
  #  key = key.to_s

  #  found = @registry[key]

  #  if found == provider
  #    if found.proxy
  #      @registry[key] = found.proxy
  #    else
  #      @registry.delete key
  #    end
  #  end
  #end

  def self.clear
    @registry.clear
  end
  #def self.clear *keys
  #  if keys.length > 0
  #    keys.each {|key| @registry.delete key.to_s }
  #  else
  #    @registry.clear
  #  end
  #end

  #def self.providers
  #  @registry
  #end

  #def self.provider_for key
  #  @registry[key.to_s]
  #end

  #def self.not_found
  #  NOT_FOUND
  #end

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

  def self.create_provider key, value, options, &block
    if block_given?
      Provider.new key, NOT_FOUND, options, &block
    elsif value.respond_to? :call
      Provider.new key, value, options
    else
      SimpleProvider.new key, value, options
    end
  end
end

