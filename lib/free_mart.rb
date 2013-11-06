module FreeMart
  @providers = {}

  def self.register name, value
    @providers[name] = value
  end

  def self.request name
    @providers[name]
  end
end

