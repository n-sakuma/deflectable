def mock_env(remote_addr, path = '/')
  Rack::MockRequest.env_for path, { 'REMOTE_ADDR' => remote_addr }
end

def mock_deflecter(app, options = {})
  Deflectable::Watcher.new(app, options)
end

