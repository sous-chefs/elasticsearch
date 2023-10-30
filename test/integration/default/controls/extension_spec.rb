auth_data = 'testuser:testpass@'

control 'Elasticsearch plugin' do
  describe http("http://#{auth_data}127.0.0.1:9200/_cat/plugins") do
    its('status') { should eq 200 }
    its('body') { should match(/analysis-icu/) }
    its('body') { should match(/mapper-size/) }
  end
end
