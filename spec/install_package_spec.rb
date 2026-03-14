# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_install_package' do
  step_into :elasticsearch_install_package
  platform 'ubuntu', '22.04'

  context 'action :install on debian' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '7.17.9'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/elasticsearch-7.17.9-amd64.deb") }
    it { is_expected.to install_dpkg_package('elasticsearch-7.17.9-amd64.deb') }
  end

  context 'action :install on rhel' do
    platform 'almalinux', '9'

    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '7.17.9'
      end
    end

    it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/elasticsearch-7.17.9-x86_64.rpm") }
    it { is_expected.to install_package('elasticsearch-7.17.9-x86_64.rpm') }
  end

  context 'action :remove' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install_package 'elasticsearch' do
        version '7.17.9'
        action :remove
      end
    end

    it { is_expected.to remove_package("#{Chef::Config[:file_cache_path]}/elasticsearch-7.17.9-amd64.deb") }
  end
end
