require_relative 'spec_helper'

shared_examples_for 'elasticsearch install' do |args = {}|
  dir = args[:dir] || '/usr/local'
  version = args[:version] || '1.7.3'
  package_name = args[:package] || false

  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'

  describe file("#{dir}/elasticsearch-#{version}") do
    it { should be_directory }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }
  end

  describe file("#{dir}/elasticsearch") do
    it { should be_symlink }
  end

  describe file('/usr/local/bin/elasticsearch') do
    it { should be_symlink }
    it { should be_linked_to("#{dir}/elasticsearch-#{version}/bin/elasticsearch") }
  end

  if package_name
    describe package(package_name) do
      it { should be_installed }
    end
  end
end
