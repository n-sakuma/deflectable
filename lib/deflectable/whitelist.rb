require 'ipaddr'
class Deflectable::Whitelist
  def initialize(options)
    @list = parse_ipaddress(options[:whitelist])
  end

  def permit?(request_ip)
    @list.any?{|ip| ip.include?(request_ip)}
  end


  private

  def parse_ipaddress(list)
    list.map do |ip|
      IPAddr.new(ip).to_range rescue nil
    end.compact
  end
end
