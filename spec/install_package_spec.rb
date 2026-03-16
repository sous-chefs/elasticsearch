# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_install_package' do
  step_into :elasticsearch_install_package, :elasticsearch_user
  platform 'ubuntu', '22.04'

  context 'action :install on debian' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/elasticsearch-8.19.12-amd64.deb") }
    it { is_expected.to install_dpkg_package('elasticsearch-8.19.12-amd64.deb') }
  end

  context 'action :install on rhel' do
    platform 'almalinux', '9'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/elasticsearch-8.19.12-x86_64.rpm") }
    it { is_expected.to install_package('elasticsearch-8.19.12-x86_64.rpm') }
  end

  context 'action :install on suse' do
    platform 'opensuse', '15'

    before do
      stub_command('rpm -q gpg-pubkey --qf "%{summary}\n" | grep -q Elasticsearch').and_return(false)
    end

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '8.19.12'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/elasticsearch-8.19.12-x86_64.rpm") }
    it { is_expected.to run_execute('import elasticsearch GPG key') }
    it { is_expected.to install_package('elasticsearch-8.19.12-x86_64.rpm') }
  end

  context 'action :remove' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '8.19.12'
        action :remove
      end
    end

    it { is_expected.to remove_package("#{Chef::Config[:file_cache_path]}/elasticsearch-8.19.12-amd64.deb") }
  end
end
