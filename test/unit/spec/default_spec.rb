# Encoding: utf-8

require_relative 'spec_helper'

describe 'elasticsearch::default' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        # any platform specific data you want available to your test can be loaded here
        property = load_platform_properties(platform: platform, platform_version: version)

        # added as an example, but this probably isn't a great one, since we shouldn't be
        # testing resources that are not created/executed by our cookbook.
        it 'upgrades curl' do

          # example of using a platform specific property to override a package name
          curl_package_name = property['curl_package'] || 'curl'

          # ensure package is installed (action is :upgrade)
          expect(chef_run).to upgrade_package(curl_package_name)

        end

        it 'creates a dummy ruby block for test coverage' do
          expect(chef_run).to run_ruby_block('dummy_block for test coverage')
        end

      end
    end
  end
end
