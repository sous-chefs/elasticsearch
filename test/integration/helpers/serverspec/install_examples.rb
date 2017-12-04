require_relative 'spec_helper'

shared_examples_for 'elasticsearch install' do |args = {}|
  dir = args[:dir] || '/usr/share'
  version = args[:version] || '6.0.0'

  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'

  describe file("#{dir}/elasticsearch-#{version}"), if: tarball? do
    it { should be_directory }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }
  end

  describe file("#{dir}/elasticsearch"), if: tarball? do
    it { should be_symlink }
  end

  describe file('/usr/local/bin/elasticsearch'), if: tarball? do
    it { should be_symlink }
    it { should be_linked_to("#{dir}/elasticsearch-#{version}/bin/elasticsearch") }
  end

  describe package('elasticsearch'), if: package? do
    it { should be_installed }
  end
end
