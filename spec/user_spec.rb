# frozen_string_literal: true

require_relative 'spec_helper'

describe 'elasticsearch_user' do
  step_into :elasticsearch_user
  platform 'ubuntu', '22.04'

  context 'action :create with defaults' do
    recipe do
      elasticsearch_user 'elasticsearch'
    end

    it { is_expected.to create_group('elasticsearch') }
    it { is_expected.to create_user('elasticsearch') }
  end

  context 'action :create with custom properties' do
    recipe do
      elasticsearch_user 'custom' do
        username 'esuser'
        groupname 'esgroup'
        uid 1001
        gid 2001
        shell '/bin/sh'
        comment 'Custom ES User'
      end
    end

    it { is_expected.to create_group('esgroup') }
    it { is_expected.to create_user('esuser').with(shell: '/bin/sh', comment: 'Custom ES User') }
  end

  context 'action :remove' do
    recipe do
      elasticsearch_user 'elasticsearch' do
        action :remove
      end
    end

    it { is_expected.to remove_user('elasticsearch') }
    it { is_expected.to remove_group('elasticsearch') }
  end
end
