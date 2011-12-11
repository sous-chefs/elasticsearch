# Inserts example data into ES to test persistence across restarts, etc
#
bash "Insert example data and perform search" do
  user node.elasticsearch[:user]

  code <<-EOS
    HOST=http://localhost:9200
    curl -X DELETE $HOST/test/; echo

    curl -X POST $HOST/test/document -d '{"title" : "Test 1", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test/document -d '{"title" : "Test 2", "time" : "#{Time.now.utc}", "enabled" : false}'; echo
    curl -X POST $HOST/test/document -d '{"title" : "Test 3", "time" : "#{Time.now.utc}", "enabled" : false}'; echo
    curl -X POST $HOST/test/document -d '{"title" : "Test 4", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test/document -d '{"title" : "Test 5", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test/_refresh; echo

    curl "$HOST/test/_search?q=Test&size=1&pretty"; echo
  EOS

end
