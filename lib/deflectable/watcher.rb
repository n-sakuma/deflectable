require 'thread'

module Deflectable
  class Watcher
    attr_accessor :options

    def initialize(app, options = {})
      @app = app
      @remote_addr_map = {}
      # TODO: extract rails conf
      conf = YAML.load_file(Rails.root.join('config/deflect.yml')) rescue {}
      @options = {
        :log => false,
        :log_format => 'deflect(%s): %s',
        :log_date_format => '%m/%d/%Y',
        :request_threshold => 100,
        :interval => 5,
        :block_duration => 900,
        :whitelist => [],
        :blacklist => [],
      }.merge(conf).merge(options)
      # TODO: conf check
    end

    def call(env)
      return reject! if detect?(env)
      status, headers, body = @app.call(env)
      [status, headers, body]
    end

    def reject!
      res = Rack::Response.new do |r|
        r.status = 403
        r['Content-Type'] = 'text/html;charset=utf-8'
        r.write error_content
      end
      res.finish
    end

    def error_content
      if defined? Rails
        File.read(Rails.root.join('public/403.html'))
      else
        '<p>failed</p>'
      end
    end

    def detect?(env)
      @remote_addr = env['REMOTE_ADDR']
      if !options[:whitelist].empty?
        allowed?(env) ? false : true
      else
        denied?(env) ? true : false
      end
    end

    def allowed?(env)
      return true if options[:whitelist].empty?
      options[:whitelist].include?(env['REMOTE_ADDR']) ? true : false
    end

    def denied?(env)
      return true if options[:blacklist].empty?
      options[:blacklist].include?(env['REMOTE_ADDR']) ? true : false
    end

    def log message
      return unless options[:log]
      options[:log].puts(options[:log_format] % [Time.now.strftime(options[:log_date_format]), message])
    end
  end
end
