# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'create mapfiles' do
  describe 'one mapfile' do
    let(:pp) do
      <<-MANIFEST
      include ::haproxy
      haproxy::mapfile { 'single-mapfile':
        ensure   => 'present',
        mappings => [
          { 'example.com' => 'bk_com' },
          { 'example.net' => 'bk_net' },
          { 'example.edu' => 'bk_edu' },
        ],
      }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file('/etc/haproxy/single-mapfile.map')).to be_file
      expect(file('/etc/haproxy/single-mapfile.map').content).to match "example.com bk_com\nexample.net bk_net\nexample.edu bk_edu\n"
    end
  end

  describe 'multiple mapfiles' do
    let(:pp) do
      <<-MANIFEST
      include ::haproxy
      haproxy::mapfile { 'multiple-mapfiles':
        ensure => 'present',
      }
      haproxy::mapfile::entry { 'example.com bk_com':
        mapfile => 'multiple-mapfiles',
      }
      haproxy::mapfile::entry { 'org':
        mappings => ['example.org bk_org'],
        mapfile  => 'multiple-mapfiles',
        order    => '05',
      }
      haproxy::mapfile::entry { 'net':
        mappings => ['example.net bk_net'],
        mapfile  => 'multiple-mapfiles',
      }
      haproxy::mapfile::entry { 'edu':
        mappings => [{'example.edu' => 'bk_edu'}],
        mapfile  => 'multiple-mapfiles',
      }
      MANIFEST
    end

    it 'applies the manifest twice with no stderr' do
      idempotent_apply(pp)
      expect(file('/etc/haproxy/multiple-mapfiles.map')).to be_file
      expect(file('/etc/haproxy/multiple-mapfiles.map').content).to match "example.org bk_org\nexample.edu bk_edu\nexample.com bk_com\nexample.net bk_net\n"
    end
  end

  describe 'check selection of correct backend' do
    describe 'single mapfile' do
      let(:pp) do
        <<-MANIFEST
          $error_page_content = @(ERROR_PAGE)
            HTTP/1.1 421 Misdirected Request
            Cache-Control: no-cache
            Connection: close
            Content-Type: text/plain

            Error Page
            |ERROR_PAGE

        file { '/tmp/error.html.http':
          content => $error_page_content,
        }
        file_line {'localhost':
          path  => '/etc/hosts',
          line  => '127.0.0.1 localhost host2 host3',
          match => '^127.0.0.1',
        }
        include ::haproxy
        haproxy::mapfile { 'single-mapfile':
          ensure   => 'present',
          mappings => [
            { 'host2' => 'backend2' },
            { 'host3' => 'backend3' },
          ],
        }
        haproxy::frontend { 'test00':
          ipaddress => '127.0.0.1',
          ports     => 5555,
          mode      => 'http',
          options   => {
            'use_backend' => '%[req.hdr(host),lower,map_dom(/etc/haproxy/single-mapfile.map,backend1)]'
          },
        }
        haproxy::backend { 'backend1':
          mode    => 'http',
          options => [
            {
              'errorfile' => [
                '503 /tmp/error.html.http',
              ],
            },
          ],
        }
        haproxy::backend { 'backend2':
          defaults         => 'http',
          collect_exported => false,
          options          => { 'mode' => 'http' },
        }
        haproxy::balancermember { 'port 5556':
          listening_service => 'backend2',
          server_names      => 'test00.example.com',
          defaults          => 'http',
          ports             => 5556,
        }
        haproxy::backend { 'backend3':
          defaults         => 'http',
          collect_exported => false,
          options          => { 'mode' => 'http' },
        }
        haproxy::balancermember { 'port 5557':
          listening_service => 'backend3',
          server_names      => 'test01.example.com',
          defaults          => 'http',
          ports             => 5557,
        }
        MANIFEST
      end

      it 'is able to listen with a mapfile' do
        retry_on_error_matching do
          apply_manifest(pp, catch_failures: true)
        end
      end

      it 'has a complete mapfile' do
        expect(file('/etc/haproxy/single-mapfile.map')).to be_file
        expect(file('/etc/haproxy/single-mapfile.map').content).to match "host2 backend2\nhost3 backend3\n"
      end

      it 'selects the correct backend based on host' do
        expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Error Page})
        expect(run_shell('curl host2:5555').stdout.chomp).to match(%r{Response on 5556})
        expect(run_shell('curl host3:5555').stdout.chomp).to match(%r{Response on 5557})
      end
    end

    describe 'multiple mapfiles' do
      let(:pp) do
        <<-MANIFEST
          $error_page_content = @(ERROR_PAGE)
            HTTP/1.1 421 Misdirected Request
            Cache-Control: no-cache
            Connection: close
            Content-Type: text/plain

            Error Page
            |ERROR_PAGE

        file { '/tmp/error.html.http':
          content => $error_page_content,
        }
        file_line {'localhost':
          path  => '/etc/hosts',
          line  => '127.0.0.1 localhost host2 host3',
          match => '^127.0.0.1',
        }
        include ::haproxy
        haproxy::mapfile { 'multiple-mapfiles':
          ensure   => 'present',
        }
        haproxy::mapfile::entry { 'host2 backend2':
          mapfile  => 'multiple-mapfiles',
        }
        haproxy::mapfile::entry { 'host3 backend3':
          mapfile  => 'multiple-mapfiles',
        }
        haproxy::frontend { 'test00':
          ipaddress => '127.0.0.1',
          ports     => 5555,
          mode      => 'http',
          options   => {
            'use_backend' => '%[req.hdr(host),lower,map_dom(/etc/haproxy/single-mapfile.map,backend1)]'
          },
        }
        haproxy::backend { 'backend1':
          mode    => 'http',
          options => [
            {
              'errorfile' => [
                '503 /tmp/error.html.http',
              ],
            },
          ],
        }
        haproxy::backend { 'backend2':
          defaults         => 'http',
          collect_exported => false,
          options          => { 'mode' => 'http' },
        }
        haproxy::balancermember { 'port 5556':
          listening_service => 'backend2',
          server_names      => 'test00.example.com',
          defaults          => 'http',
          ports             => 5556,
        }
        haproxy::backend { 'backend3':
          defaults         => 'http',
          collect_exported => false,
          options          => { 'mode' => 'http' },
        }
        haproxy::balancermember { 'port 5557':
          listening_service => 'backend3',
          server_names      => 'test01.example.com',
          defaults          => 'http',
          ports             => 5557,
        }
        MANIFEST
      end

      it 'is able to listen with a mapfile' do
        retry_on_error_matching do
          apply_manifest(pp, catch_failures: true)
        end
      end

      it 'has a complete mapfile' do
        expect(file('/etc/haproxy/multiple-mapfiles.map')).to be_file
        expect(file('/etc/haproxy/multiple-mapfiles.map').content).to match "host2 backend2\nhost3 backend3\n"
      end

      it 'selects the correct backend based on host' do
        expect(run_shell('curl localhost:5555').stdout.chomp).to match(%r{Error Page})
        expect(run_shell('curl host2:5555').stdout.chomp).to match(%r{Response on 5556})
        expect(run_shell('curl host3:5555').stdout.chomp).to match(%r{Response on 5557})
      end
    end
  end
end
