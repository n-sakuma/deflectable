require 'logger'
module Deflectable
  class Watcher
    attr_accessor :options

    def initialize(app, build_options={}, &block = nil)
      @app = app
      @filtering = nil
      @options = {
        :log => false,
        :logger => nil,
        :log_format => 'deflect(%s): %s',
        :log_date_format => '%m/%d/%Y',
        :whitelist => [],
        :blacklist => [],
      }.merge(build_options)
      @options = @options.merge(block.call) if block_given?
      configure_check!
    end

    def call(env)
      return reject!(env) unless permit?(env)
      status, headers, body = @app.call(env)
      [status, headers, body]
    end


    private

    def configure_check!
      set_rails_configure!
      if (not options[:whitelist].empty?) and (not options[:blacklist].empty?)
        raise <<-EOS
There was both a :blanklist and :whitelist.
`Please select the :blacklist or :whitelist.'
        EOS
      end
      @filtering = Whitelist.new(options) unless options[:whitelist].empty?
      @filtering = Blacklist.new(options) unless options[:blacklist].empty?
      unless options[:logger]
        self.options[:logger] = Logger.new('deflecter.log')
      end
    end

    def set_rails_configure!
      return unless defined?(Rails)
      conf = YAML.load_file(Rails.root.join('config/deflectable.yml'))
      self.options = options.merge(conf).merge(:logger => Rails.logger)
    rescue => e
      log e.message
    end

    def reject!(env)
      res = Rack::Response.new do |r|
        r.status = 403
        r['Content-Type'] = 'text/html;charset=utf-8'
        r.write error_content
      end
      log "Rejected(#{@filtering}): #{env['REMOTE_ADDR']}"
      res.finish
    end

    def error_content
      File.read(Rails.root.join('public/403.html'))
    rescue
      '<p>failed</p>'
    end

    def permit?(env)
      return true unless @filtering
      @filtering.permit?(env['REMOTE_ADDR'])
    end

    def log(message, level = :info)
      return unless options[:log]
      if logger = options[:logger]
        logger.send(level, message)
      else
        STDOUT.puts(options[:log_format] % [Time.now.strftime(options[:log_date_format]), message])
      end
    end
  end
end
