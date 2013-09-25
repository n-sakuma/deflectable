require 'spec_helper'

describe Deflectable::Watcher do
  context 'whitelist' do
    before do
      @app = lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['cookies']] }
      @allow_ip    = '111.111.111.111'
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
  end

end
