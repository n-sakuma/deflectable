require 'thread'

module Deflectable
  class Watcher
    attr_accessor :options

    def initialize(app, options = {})
      @mutex = Mutex.new
      @app = app
      conf = YAML.load_file(Rails.root.join('config/deflect.yml')) rescue {}
      @options = {
        :log => true,
        :log_format => 'deflect(%s): %s',
        :log_date_format => '%m/%d/%Y',
        :request_threshold => 100,
        :interval => 5,
        :block_duration => 900,
        :whitelist => [],
        :blacklist => [],
      }.merge(conf)
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
        r.write File.read(Rails.root.join('public/403.html'))
      end
      res.finish
    end

    def detect?(env)
      @remote_addr = env['REMOTE_ADDR']
      return false if options[:whitelist].include? @remote_addr
      return true  if options[:blacklist].include? @remote_addr
      @mutex.synchronize { watch }
    end

    def watch
      increment_requests
      clear! if watch_expired? and not blocked?
      clear! if blocked? and block_expired?
      block! if watching? and exceeded_request_threshold?
      blocked?
    end

    def map
      @remote_addr_map[@remote_addr] ||= {
        :expires => Time.now + options[:interval],
        :requests => 0
      }
    end

    def block!
      return if blocked?
      log "blocked #{@remote_addr}"
      map[:block_expires] = Time.now + options[:block_duration]
    end

    def blocked?
      map.has_key? :block_expires
    end

    def block_expired?
      map[:block_expires] < Time.now rescue false
    end

    def watching?
      @remote_addr_map.has_key? @remote_addr
    end

    def clear!
      return unless watching?
      log "released #{@remote_addr}" if blocked?
      @remote_addr_map.delete @remote_addr
    end

    def increment_requests
      map[:requests] += 1
    end

    def exceeded_request_threshold?
      map[:requests] > options[:request_threshold]
    end

    def watch_expired?
      map[:expires] <= Time.now
    end

    def log message
      return unless options[:log]
      options[:log].puts(options[:log_format] % [Time.now.strftime(options[:log_date_format]), message])
    end
  end
end
