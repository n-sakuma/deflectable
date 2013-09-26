require 'spec_helper'

describe Deflectable::Watcher do
  context 'whitelist' do
    before do
      @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['cookies']] }
      @allow_ip    = '111.111.111.111'
      @allow_ip_range = '111.111.111.0/24'
      @not_in_list = '123.123.123.123'
      @invalid_ip  = '333.333.333.333'
      @deflectable = mock_deflecter(@app, {:whitelist => [@allow_ip]})
    end

    it 'successfully' do
      status, headers, body = @deflectable.call(mock_env(@allow_ip))
      status.should == 200
      headers.should == { 'Content-Type' => 'text/plain' }
      body.should == ['cookies']
    end

    it 'failded' do
      status, headers, body = @deflectable.call(mock_env(@not_in_list))
      status.should == 403
      headers['Content-Type'].should == 'text/html;charset=utf-8'
      body.should_not be_empty
    end

    it 'no defined whitelist' do
      deflectable = mock_deflecter(@app)
      status, headers, body = deflectable.call(mock_env(@not_in_list))
      status.should == 200
      headers.should == { 'Content-Type' => 'text/plain' }
      body.should == ['cookies']
    end

    it 'successfully for address list' do
      deflectable = mock_deflecter(@app, {:whitelist => [@allow_ip_range]})
      status, headers, body = deflectable.call(mock_env(@allow_ip))
      status.should == 200
      headers.should == { 'Content-Type' => 'text/plain' }
      body.should == ['cookies']
    end

    it 'invalid ip is ignore' do
      deflectable = mock_deflecter(@app, {:whitelist => [@invalid_ip]})
      whitelist = deflectable.instance_variable_get(:@filtering).instance_variable_get(:@list)
      whitelist.should be_empty
    end
  end

  context 'blacklist' do

    before do
      @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['cookies']] }
      @deny_ip     = '111.111.111.111'
      @not_in_list = '123.123.123.123'
      @invalid_ip  = '333.333.333.333'
      @deflectable = mock_deflecter(@app, {:blacklist => [@deny_ip]})
    end

    it "deny ip is don't access" do
      status, headers, body = @deflectable.call(mock_env(@deny_ip))
      status.should == 403
      headers['Content-Type'].should == 'text/html;charset=utf-8'
      body.should_not be_empty
    end

    it 'not in listed ip is successfully' do
      status, headers, body = @deflectable.call(mock_env(@not_in_list))
      status.should == 200
      headers.should == { 'Content-Type' => 'text/plain' }
      body.should == ['cookies']
    end

    it 'no defined whitelist is successfully' do
      deflectable = mock_deflecter(@app)
      status, headers, body = deflectable.call(mock_env(@not_in_list))
      status.should == 200
      headers.should == { 'Content-Type' => 'text/plain' }
      body.should == ['cookies']
    end
  end

end
