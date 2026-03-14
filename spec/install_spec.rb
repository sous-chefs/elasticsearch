# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_install' do
  step_into :elasticsearch_install
  platform 'ubuntu', '22.04'

  context 'type repository (default)' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch'
    end

    it { is_expected.to install_elasticsearch_install_repository('ElasticSearch 7.17.9') }
  end

  context 'type package' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch' do
        type 'package'
      end
    end

    it { is_expected.to install_elasticsearch_install_package('ElasticSearch 7.17.9') }
  end

  context 'type tarball raises error' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch' do
        type 'tarball'
      end
    end

    it 'raises an error' do
      expect { chef_run }.to raise_error(RuntimeError, /Tarball method is not currently supported/)
    end
  end

  context 'action :remove with repository type' do
    recipe do
      elasticsearch_user 'elasticsearch'
      elasticsearch_install 'elasticsearch' do
        action :remove
      end
    end

    it { is_expected.to remove_elasticsearch_install_repository('ElasticSearch 7.17.9') }
  end
end
