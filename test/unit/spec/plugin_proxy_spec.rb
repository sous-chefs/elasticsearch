require_relative 'spec_helper'
require_relative '../../../libraries/helpers.rb'

describe 'elasticsearch_test::default_with_plugins' do
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
        _property = load_platform_properties(platform: platform, platform_version: version)

        before do
          extend ElasticsearchCookbook::Helpers
          Chef::Config['http_proxy'] = nil
          Chef::Config['https_proxy'] = nil
        end

        it 'installs elasticsearch without proxy' do
          args = get_java_proxy_arguments
          expect(args).to eq('')
        end

        it 'installs elasticsearch with proxy host' do
          Chef::Config['http_proxy'] = 'http://example.com'
          args = get_java_proxy_arguments
          expect(args).to eq('-Dhttp.proxyHost=example.com -Dhttp.proxyPort=80 ')
        end

        it 'installs elasticsearch with proxy' do
          Chef::Config['http_proxy'] = 'http://example.com:8080'
          args = get_java_proxy_arguments
          expect(args).to eq('-Dhttp.proxyHost=example.com -Dhttp.proxyPort=8080 ')
        end

        it 'installs elasticsearch with proxy host (ssl)' do
          Chef::Config['https_proxy'] = 'https://example.com'
          args = get_java_proxy_arguments
          expect(args).to eq('-Dhttps.proxyHost=example.com -Dhttps.proxyPort=443 ')
        end

        it 'installs elasticsearch with proxy (ssl)' do
          Chef::Config['https_proxy'] = 'https://example.com:8080'
          args = get_java_proxy_arguments
          expect(args).to eq('-Dhttps.proxyHost=example.com -Dhttps.proxyPort=8080 ')
        end
      end
    end
  end
end
