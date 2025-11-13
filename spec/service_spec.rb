require_relative 'spec_helper'

describe 'elasticsearch_service' do
  before { stub_resources }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_service']) do |node, server|
            node_resources(node)
            stub_chef_zero(platform, version, server)
          end.converge('test::restart_policy')
        end

        it 'creates systemd unit with restart policy' do
          expect(chef_run).to create_systemd_unit('elasticsearch').with(
            content: hash_including(
              Service: hash_including(
                Restart: 'on-failure',
                RestartSec: 30
              )
            )
          )
        end

        it 'enables and starts the elasticsearch service' do
          expect(chef_run).to enable_service('elasticsearch')
          expect(chef_run).to start_service('elasticsearch')
        end
      end
    end
  end

  # Test default behavior (no restart)
  context 'with default configuration' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '20.04', step_into: ['elasticsearch_service']) do |node, server|
        node_resources(node)
        stub_chef_zero('ubuntu', '20.04', server)
      end.converge_block do
        elasticsearch_user 'elasticsearch'
        elasticsearch_install 'elasticsearch' do
          type 'package'
        end
        elasticsearch_configure 'elasticsearch'
        elasticsearch_service 'elasticsearch'
      end
    end

    it 'creates systemd unit without restart policy' do
      systemd_unit = chef_run.systemd_unit('elasticsearch')
      expect(systemd_unit.content[:Service]).not_to have_key(:Restart)
      expect(systemd_unit.content[:Service]).not_to have_key(:RestartSec)
    end
  end
end
