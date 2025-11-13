control 'Service restart configuration' do
  impact 1.0
  title 'Elasticsearch service restart policy configuration'
  desc 'Verify that restart policy is correctly configured in systemd unit'

  # Test that the systemd service file exists
  describe file('/etc/systemd/system/elasticsearch.service') do
    it { should exist }
  end

  # Test restart policy configuration if the test recipe was used
  if file('/etc/systemd/system/elasticsearch.service').exist?
    service_content = file('/etc/systemd/system/elasticsearch.service').content

    # Check if this is the restart_policy test
    if service_content.include?('Restart=on-failure')
      describe 'Elasticsearch service restart configuration' do
        it 'should have restart policy configured' do
          expect(service_content).to match(/^Restart=on-failure$/)
        end

        it 'should have restart delay configured' do
          expect(service_content).to match(/^RestartSec=30$/)
        end
      end
    else
      describe 'Elasticsearch service default configuration' do
        it 'should not have restart policy by default' do
          expect(service_content).not_to match(/^Restart=/)
        end

        it 'should not have restart delay by default' do
          expect(service_content).not_to match(/^RestartSec=/)
        end
      end
    end
  end
end
