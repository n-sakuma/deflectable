class Deflectable::Whitelist
  def initialize(options)
    @list = options[:whitelist]
  end

  def permit?(ip)
    @list.include?(ip)
  end
end
