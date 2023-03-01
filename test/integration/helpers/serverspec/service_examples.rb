require_relative 'spec_helper'

shared_examples_for 'elasticsearch service' do |service_name = 'elasticsearch', args = {}|
  content_match = args[:content] || 'elasticsearch'

  describe file("/usr/lib/systemd/system/#{service_name}.service") do
    it { should be_file }
    it { should be_mode 644 }

    if package?
      its(:content) { should contain(/ES_SD_NOTIFY=true/) }
    else
      its(:content) { should_not contain(/ES_SD_NOTIFY=true/) }
    end
  end

  # we should move to inspec here ASAP, as this doesn't pass due to serverspec
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  # always sleep before checking the service; it needs time to stabilize
  describe command('sleep 30') do
    its(:exit_status) { should eq 0 }
  end

  describe command('curl http://testuser:testpass@localhost:9200') do
    its(:stdout) { should match(/#{content_match}/) }
  end
end
