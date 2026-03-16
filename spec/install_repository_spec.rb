# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_install_repository' do
  step_into :elasticsearch_install_repository, :elasticsearch_user
  platform 'ubuntu', '22.04'

  context 'action :install on debian' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to add_apt_repository('elastic-8.x') }
    it { is_expected.to install_package('elasticsearch').with(version: '8.19.12') }
  end

  context 'action :install on rhel' do
    platform 'almalinux', '9'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to create_yum_repository('elastic-8.x') }
    it { is_expected.to install_package('elasticsearch').with(version: '8.19.12') }
  end

  context 'action :install on suse' do
    platform 'opensuse', '15'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to create_zypper_repository('elastic-8.x') }
    it { is_expected.to install_package('elasticsearch').with(version: '8.19.12') }
  end

  context 'action :install with repository actions disabled' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
        enable_repository_actions false
      end
    end

    it { is_expected.not_to add_apt_repository('elastic-8.x') }
    it { is_expected.to install_package('elasticsearch') }
  end

  context 'action :remove on debian' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
        action :remove
      end
    end

    it { is_expected.to remove_apt_repository('elastic-8.x') }
    it { is_expected.to remove_package('elasticsearch') }
  end

  context 'action :remove on rhel' do
    platform 'almalinux', '9'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
        action :remove
      end
    end

    it { is_expected.to remove_yum_repository('elastic-8.x') }
    it { is_expected.to remove_package('elasticsearch') }
  end

  context 'action :remove on suse' do
    platform 'opensuse', '15'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_repository 'elasticsearch' do
        version '8.19.12'
        action :remove
      end
    end

    it { is_expected.to remove_zypper_repository('elastic-8.x') }
    it { is_expected.to remove_package('elasticsearch') }
  end
end
