require 'spec_helper'

describe 'haproxy::mailer' do
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

  context 'with a single mailer' do
    let(:params) do
      {
        :mailers_name => 'tyler',
        :port       => 1024,
      }
    end

    it { should contain_concat__fragment('haproxy-mailers-tyler-dero').with(
      'order'   => '40-mailers-01-tyler-dero',
      'target'  => '/tmp/haproxy.cfg',
      'content' => "  mailer dero 1.1.1.1:1024\n"
    ) }
  end
end
