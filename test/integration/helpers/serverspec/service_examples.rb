require_relative 'spec_helper'

shared_examples_for 'elasticsearch service' do |service_name = 'elasticsearch', args = {}|
  content_match = args[:content] || 'elasticsearch'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('curl http://localhost:9200') do
    its(:stdout) { should match(/#{content_match}/) }
  end
end
