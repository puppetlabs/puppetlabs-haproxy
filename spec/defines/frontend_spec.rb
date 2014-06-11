require 'spec_helper'

describe 'haproxy::frontend' do
  let(:title) { 'tyler' }
  let(:facts) {{ :ipaddress => '1.1.1.1' }}
  context "when only one port is provided" do
    let(:params) do
      {
        :name  => 'croy',
        :ports => '18140'
      }
    end

    it { should contain_concat__fragment('croy_frontend_block').with(
      'order'   => '15-croy-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend croy\n  bind 1.1.1.1:18140 \n  option  tcplog\n"
    ) }
  end
  context "when an array of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => [
          '80',
          '443'
        ]
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  option  tcplog\n"
    ) }
  end
  context "when bind options are provided" do
    let(:params) do
      {
        :name         => 'apache',
        :ports        => ['80','8080'],
        :bind_options => [ 'the options', 'go here' ]
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 1.1.1.1:80 the options go here\n  bind 1.1.1.1:8080 the options go here\n  option  tcplog\n"
    ) }
  end
  context "when a comma-separated list of ports is provided" do
    let(:params) do
      {
        :name      => 'apache',
        :ipaddress => '23.23.23.23',
        :ports     => '80,443'
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  bind 23.23.23.23:443 \n  option  tcplog\n"
    ) }
  end

  context "when custom_fragment is provided" do
    let(:params) do
      {
        :name            => 'apache',
        :ipaddress       => '23.23.23.23',
        :ports           => '80',
        :custom_fragment => '  bind 23.23.23.23:443 ssl crt /path/to/cert.crt'
      }
    end

    it { should contain_concat__fragment('apache_frontend_block').with(
      'order'   => '15-apache-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nfrontend apache\n  bind 23.23.23.23:80 \n  option  tcplog\n  bind 23.23.23.23:443 ssl crt /path/to/cert.crt\n"
    ) }
  end
end
