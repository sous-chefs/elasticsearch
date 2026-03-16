# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_service' do
  step_into :elasticsearch_service, :elasticsearch_user
  platform 'ubuntu', '22.04'

  context 'with restart policy' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch' do
        type 'package'
      end
      elasticsearch_configure 'elasticsearch' do
        allocated_memory '256m'
      end
      elasticsearch_service 'elasticsearch' do
        restart_policy 'on-failure'
        restart_sec 30
      end
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

    it { is_expected.to enable_service('elasticsearch') }
    it { is_expected.to start_service('elasticsearch') }
  end

  context 'with default configuration' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch' do
        type 'package'
      end
      elasticsearch_configure 'elasticsearch' do
        allocated_memory '256m'
      end
      elasticsearch_service 'elasticsearch'
    end

    it 'creates systemd unit without restart policy' do
      systemd_unit = chef_run.systemd_unit('elasticsearch')
      expect(systemd_unit.content[:Service]).not_to have_key(:Restart)
      expect(systemd_unit.content[:Service]).not_to have_key(:RestartSec)
    end
  end
end
