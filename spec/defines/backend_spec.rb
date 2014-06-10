require 'spec_helper'

describe 'haproxy::backend' do
  let(:title) { 'tyler' }
  let(:facts) {{ :ipaddress => '1.1.1.1' }}

  context "when no options are passed" do
    let (:params) do
      {
        :name => 'bar'
      }
    end

    it { should contain_concat__fragment('bar_backend_block').with(
      'order'   => '20-bar-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nbackend bar\n  balance  roundrobin\n  option  tcplog\n  option  ssl-hello-chk\n"
    ) }
  end
  context "when custom_fragment is provided" do
    let(:params) do
      {
        :name            => 'servers',
        :custom_fragment => '  server webserver 10.0.0.20:8000 check
  server webserver 10.0.0.20:8001 check'
      }
    end

    it { should contain_concat__fragment('servers_backend_block').with(
      'order'   => '20-servers-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nbackend servers\n  balance  roundrobin\n  option  tcplog\n  option  ssl-hello-chk\n  server webserver 10.0.0.20:8000 check\n  server webserver 10.0.0.20:8001 check\n"
    ) }
  end
end


