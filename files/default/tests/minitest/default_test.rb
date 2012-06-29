require 'minitest/spec'

describe_recipe 'elasticsearch::default' do

    # It's often convenient to load these includes in a separate
  # helper along with
  # your own helper methods, but here we just include them directly:
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources
  require 'net/http'
  require 'json'

  
  it "runs as a daemon" do
    service("elasticsearch").must_be_running
  end

  it "boots on startup" do
    service("elasticsearch").must_be_enabled
  end

  it "shows green or yellow for cluster health" do
    # let's wait until the service is alive
    health_url = 'http://localhost:9200'
    timeout = 120
    until system("curl #{health_url}") or timeout == 0
       sleep 1
       timeout -= 1
    end

    cluster_url = URI.parse health_url
    resp = Net::HTTP.get_response cluster_url
    status = JSON.parse(resp.read_body)['status']
    assert status != "red"
  end

  it "test data is written and read back" do
    # let's wait until the service is alive
    test_url = 'http://localhost:9200/'

    timeout = 120
    until system("curl http://localhost:9200") or timeout == 0
       sleep 1
       timeout -= 1
    end
   
    # let's clean up first
    system("curl -X DELETE #{test_url}/test_chef_cookbook")

    # insert test data
    (1..5).each do |num|
      test_uri = URI.parse "#{test_url}/test_chef_cookbook/document/#{num}"
      system(%|curl http://localhost:9200/test_chef_cookbook/document/#{num} -d '{ "title": "Test #{num}", "time": "#{Time.now.utc}", "enabled": true }'|)
    end

    Net::HTTP.post_form URI.parse("#{test_url}/test_chef_cookbook/_refresh"), {}
    resp = Net::HTTP.get_response(URI.parse("#{test_url}/test_chef_cookbook/_search?q=Test&size=1"))
    total_hits = JSON.parse(resp.read_body)['hits']['total']

    assert total_hits == 5
  end

end
