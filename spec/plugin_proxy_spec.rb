# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../libraries/helpers'

describe ElasticsearchCookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include ElasticsearchCookbook::Helpers
    end
  end

  let(:helper) { helper_class.new }

  describe '#get_java_proxy_arguments' do
    before do
      Chef::Config['http_proxy'] = nil
      Chef::Config['https_proxy'] = nil
    end

    it 'returns empty string without proxy' do
      expect(helper.get_java_proxy_arguments).to eq('')
    end

    it 'returns http proxy arguments' do
      Chef::Config['http_proxy'] = 'http://example.com'
      expect(helper.get_java_proxy_arguments).to eq('-Dhttp.proxyHost=example.com -Dhttp.proxyPort=80 ')
    end

    it 'returns http proxy arguments with custom port' do
      Chef::Config['http_proxy'] = 'http://example.com:8080'
      expect(helper.get_java_proxy_arguments).to eq('-Dhttp.proxyHost=example.com -Dhttp.proxyPort=8080 ')
    end

    it 'returns https proxy arguments' do
      Chef::Config['https_proxy'] = 'https://example.com'
      expect(helper.get_java_proxy_arguments).to eq('-Dhttps.proxyHost=example.com -Dhttps.proxyPort=443 ')
    end

    it 'returns https proxy arguments with custom port' do
      Chef::Config['https_proxy'] = 'https://example.com:8080'
      expect(helper.get_java_proxy_arguments).to eq('-Dhttps.proxyHost=example.com -Dhttps.proxyPort=8080 ')
    end

    it 'returns empty string when proxy is disabled' do
      Chef::Config['http_proxy'] = 'http://example.com:8080'
      expect(helper.get_java_proxy_arguments(false)).to eq('')
    end
  end
end
