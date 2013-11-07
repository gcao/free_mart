require 'free_mart/provider'
require 'free_mart/provider_list'

module FreeMart
  NOT_FOUND = Object.new

  @providers = {}

  def self.register name, *rest, &block
    value, options = handle_args block_given?, *rest

    provider = if block_given?
                 Provider.new value, options, &block
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

    provider
  end

  def self.request name, *args
    raise unless @providers.has_key? name

    provider = @providers[name]
    result = if provider.respond_to? :call
               provider.call *args
             else
               provider
             end

    result == NOT_FOUND ? raise : result
  end

  def self.requestAll name, *args
    raise unless @providers.has_key? name

    provider = @providers[name]
    result = if provider.respond_to? :call
               provider.call *args
             else
               provider
             end

    result == NOT_FOUND ? raise : result
  end

  def self.reregister name, *rest, &block
    value, options = handle_args block_given?, *rest

    provider = if block_given?
                 Provider.new value, options, &block
               else
                 value
               end

    if @providers.has_key? name
      found = @providers[name]
      provider.proxy = found
    end

    @providers[name] = provider

    provider
  end

  def self.deregister name, provider
    found = @providers[name]

    if found == provider
      @providers.delete name
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

