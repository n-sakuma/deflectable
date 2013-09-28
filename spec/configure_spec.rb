require 'spec_helper'

describe Deflectable::Watcher do
  context 'whitelist and blacklist check' do
    before do
      @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['cookies']] }
      @allow_ip    = '111.111.111.111'
      @deny_ip     = '222.222.222.222'
    end
    it 'whitelist only is valid' do
      expect {Deflectable::Watcher.new(@app, {:whitelist => [@allow_ip]})}.to_not raise_error
    end
    it 'blacklist only is valid' do
      expect {Deflectable::Watcher.new(@app, {:blacklist => [@deny_ip]})}.to_not raise_error
    end
    it 'both list is error' do
      expect {Deflectable::Watcher.new(@app, {:whitelist => [@allow_ip], :blacklist => [@deny_ip]})}.to raise_error
    end
  end

  context 'config for block' do
    before do
      @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['cookies']] }
      @allow_ip    = '111.111.111.111'
    end

    it 'apply config for block' do
      whitelist = Deflectable::Watcher.new @app, {} do
        {:whitelist => [@allow_ip]}
      end.instance_variable_get(:@filtering).instance_variable_get(:@list)
      whitelist.should_not be_empty
    end

  end
end
