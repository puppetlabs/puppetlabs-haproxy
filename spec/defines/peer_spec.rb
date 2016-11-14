require 'spec_helper'

describe 'haproxy::peer' do
  let :pre_condition do
  'class{"haproxy":
      config_file => "/tmp/haproxy.cfg"
   }
  '
  end
  let(:title) { 'dero' }
  let(:facts) do
    {
      :ipaddress      => '1.1.1.1',
      :hostname       => 'dero',
      :concat_basedir => '/foo',
      :osfamily       => 'RedHat',
    }
  end

  context 'with a single peer' do
    let(:params) do
      {
        :peers_name => 'tyler',
        :port       => 1024,
      }
    end

    it { should contain_concat__fragment('haproxy-peers-tyler-dero').with(
      'order'   => '30-peers-01-tyler-dero',
      'target'  => '/tmp/haproxy.cfg',
      'content' => "  peer dero 1.1.1.1:1024\n"
    ) }
  end
end
