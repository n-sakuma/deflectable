class Deflectable::Blacklist
  def initialize(options)
    @list = options[:blacklist]
  end

  def permit?(ip)
    not @list.include?(ip)
  end
end
