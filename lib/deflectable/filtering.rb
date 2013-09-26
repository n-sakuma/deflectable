require 'ipaddr'
class Deflectable::Filtering

  def initialize(filter_list)
    @list = parse_ipaddress(filter_list)
  end

  def include?(request_ip)
    @list.any?{|ip| ip.include?(request_ip)}
  end

  private

  def parse_ipaddress(list)
    list.map do |ip|
      IPAddr.new(ip).to_range rescue nil
    end.compact
  end
end
