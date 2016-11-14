require 'spec_helper_acceptance'

describe "frontend backend defines with defaults" do
  it 'should be able to configure defaults with puppet' do
    pp = <<-EOS
      class { 'haproxy::globals':
        sort_options_alphabetic => false,
      }
      class { 'haproxy': }
      haproxy::defaults { 'http':
        options => {
          option => [
            'redispatch',
          ],
          'stats'   => 'enable',
          'log'     => 'global',
          retries => 3,
          'timeout client' => '3s',
          'timeout server' => '3s',
          'timeout connect' => '1s',
          'timeout queue' => '10s',
          'timeout check' => '1s',
          'timeout http-request' => '2s',
          balance => 'roundrobin',
          'maxconn' => '8000',

        }
      }
      haproxy::frontend { 'app00':
        ipaddress => $::ipaddress_lo,
        mode      => 'http',
        ports     => '5555',
        defaults  => 'http',
        options   => { 'default_backend' => 'app00' },
      }
      haproxy::backend { 'app00':
        defaults         => 'http',
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5556':
        listening_service => 'app00',
        defaults          => 'http',
        ports             => '5556',
      }
     haproxy::balancermember { 'port 5557':
        listening_service => 'app00',
        defaults          => 'http',
        ports             => '5557',
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
  end

  it "should do a curl against the LB to make sure it gets a response from each port" do
    #shell('cat /etc/haproxy/haproxy.cfg').stdout.should match(/^$/)
    shell('curl localhost:5555').stdout.chomp.should match(/Response on 555(6|7)/)
    shell('curl localhost:5555').stdout.chomp.should match(/Response on 555(6|7)/)
  end

  it 'should be able to configure defaults and old style with puppet' do
    pp = <<-EOS
      class { 'haproxy::globals':
        sort_options_alphabetic => false,
      }
      class { 'haproxy': }
      haproxy::defaults { 'http':
        options => {
          option => [
            'redispatch',
          ],
          'stats'   => 'enable',
          'log'     => 'global',
          retries => 3,
          'timeout client' => '3s',
          'timeout server' => '3s',
          'timeout connect' => '1s',
          'timeout queue' => '10s',
          'timeout check' => '1s',
          'timeout http-request' => '2s',
          balance => 'roundrobin',
          'maxconn' => '8000',

        }
      }
      haproxy::frontend { 'app00':
        ipaddress => $::ipaddress_lo,
        mode      => 'http',
        ports     => '5555',
        defaults  => 'http',
        options   => { 'default_backend' => 'app00' },
      }
      haproxy::backend { 'app00':
        defaults         => 'http',
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5556':
        listening_service => 'app00',
        defaults          => 'http',
        ports             => '5556',
      }
      haproxy::frontend { 'app01':
        ipaddress => $::ipaddress_lo,
        mode      => 'http',
        ports     => '6666',
        options   => { 'default_backend' => 'app01' },
      }
      haproxy::backend { 'app01':
        collect_exported => false,
        options          => { 'mode' => 'http' },
      }
      haproxy::balancermember { 'port 5557':
        listening_service => 'app01',
        ports             => '5557',
      }
    EOS
    apply_manifest(pp, :catch_failures => true)
  end

  it "should do a curl against the LB to make sure it gets a response from each port" do
    #shell('cat /etc/haproxy/haproxy.cfg').stdout.should match(/^$/)
    shell('curl localhost:5555').stdout.chomp.should match(/Response on 5556/)
    shell('curl localhost:6666').stdout.chomp.should match(/Response on 5557/)
  end
end
