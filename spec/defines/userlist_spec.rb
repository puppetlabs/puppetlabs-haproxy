require 'spec_helper'

describe 'haproxy::userlist' do
  let(:pre_condition) { 'include haproxy' }
  let(:title) { 'admins' }
  let(:facts) do
    {
      :ipaddress      => '1.1.1.1',
      :osfamily       => 'Redhat',
      :concat_basedir => '/dne',
    }
  end

  context "when users and groups are passed" do
    let (:params) do
      {
        :name => "admins",
        :users => [
          'scott insecure-password elgato',
          'kitchen insecure-password foobar' 
        ],
        :groups => [
          'superadmins users kitchen scott',
          'megaadmins users kitchen'
        ]
      }
    end

    it { should contain_concat__fragment('haproxy-admins_userlist_block').with(
      'order'   => '12-admins-00',
      'target'  => '/etc/haproxy/haproxy.cfg',
      'content' => "\nuserlist admins\n  group superadmins users kitchen scott\n  group megaadmins users kitchen\n  user scott insecure-password elgato\n  user kitchen insecure-password foobar\n"
    ) }

  end

  context "when a non-default config file is used" do
    let(:pre_condition) { 'class { "haproxy": config_file => "/etc/non-default.cfg" }' }
    let(:params) do
      {
        :name => 'bar',
        :users => [
          'scott insecure-password elgato',
        ],
        :groups => [
          'superuser users scott',
        ],
      }
    end
    it { should contain_concat__fragment('haproxy-bar_userlist_block').with(
      'order' => '12-bar-00',
      'target' => '/etc/non-default.cfg',
      'content' => "\nuserlist bar\n  group superuser users scott\n  user scott insecure-password elgato\n",
    ) }
  end
end
