require 'spec_helper'

describe 'haproxy::mailers' do
  let :pre_condition do
  'class{"haproxy":
      config_file => "/tmp/haproxy.cfg"
   }
  '
  end
  let(:facts) {{
    :ipaddress      => '1.1.1.1',
    :concat_basedir => '/foo',
    :osfamily       => 'RedHat',
  }}

  context "when no options are passed" do
    let(:title) { 'bar' }

    it { should contain_concat__fragment('haproxy-bar_mailers_block').with(
      'order'   => '40-mailers-00-bar',
      'target'  => '/tmp/haproxy.cfg',
      'content' => "\nmailers bar\n"
    ) }
  end
end
