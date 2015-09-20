require_relative 'spec_helper'

shared_examples_for 'elasticsearch plugin' do |plugin_name, args = {}|

  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'
  expected_home = args[:home] || "/usr/local/#{expected_user}"


  describe file("#{expected_home}/plugins/#{plugin_name}") do
    it { should be_directory }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }
  end

end
