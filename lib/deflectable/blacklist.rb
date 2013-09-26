class Deflectable::Blacklist < Deflectable::Filtering

  def initialize(options)
    super(options[:blacklist])
  end

  def permit?(request_ip)
    not include?(request_ip)
  end
end
