class Deflectable::Whitelist < Deflectable::Filtering

  def initialize(options)
    super(options[:whitelist])
  end

  def permit?(request_ip)
    include?(request_ip)
  end
end
