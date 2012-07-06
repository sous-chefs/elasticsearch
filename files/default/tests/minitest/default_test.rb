require 'minitest/spec'

describe_recipe 'elasticsearch::default' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  require 'net/http'
  require 'json'

  cluster_url = 'http://localhost:9200'
  health_url  = "#{cluster_url}/_cluster/health"

  it "runs as a daemon" do
    service("elasticsearch").must_be_running
  end

  it "boots on startup" do
    service("elasticsearch").must_be_enabled
  end

  it "shows green or yellow for cluster health" do
    # Let's wait until the service is alive
    timeout = 120
    until system("curl --silent --show-error '#{health_url}?wait_for_status=yellow&timeout=1m'") or timeout == 0
      sleep 1
      timeout -= 1
    end

    resp = Net::HTTP.get_response URI.parse(health_url)
    status = JSON.parse(resp.read_body)['status']
    assert status != "red"
  end

  it "test data is written and read back" do
    # Let's wait until the service is alive
    timeout = 120
    until system("curl --silent --show-error '#{health_url}?wait_for_status=yellow&timeout=1m'") or timeout == 0
      sleep 1
      timeout -= 1
    end

    # Let's clean up first
    system("curl --silent --show-error -X DELETE #{cluster_url}/test_chef_cookbook")

    # Insert test data
    (1..5).each do |num|
      test_uri = URI.parse "#{cluster_url}/test_chef_cookbook/document/#{num}"
      system(%Q|curl --silent --show-error #{cluster_url}/test_chef_cookbook/document/#{num} -d '{ "title": "Test #{num}", "time": "#{Time.now.utc}", "enabled": true }'|)
    end

    Net::HTTP.post_form URI.parse("#{cluster_url}/test_chef_cookbook/_refresh"), {}
    resp = Net::HTTP.get_response URI.parse("#{cluster_url}/test_chef_cookbook/_search?q=Test")
    total_hits = JSON.parse(resp.read_body)['hits']['total']

    assert total_hits == 5
  end

end
