# Inserts example data into ES to test persistence across restarts, etc
#
bash "Insert example data and perform search" do
  user 'root'

  code <<-EOS
    HOST=http://localhost:9200

    if [ ! $(curl -s $HOST) ]; then
      echo "(Re)starting elasticsearch..."
      su - root -c 'service elasticsearch restart'
      sleep 10
    fi

    timeout=0
    echo 'Waiting for elasticsearch...'
    until curl -s $HOST/ > /dev/null; do
      echo -n '.'
      (( timeout++ ))
      if [ $timeout -gt '120' ]; then
        echo '[!] Timeout.'
        exit 1
      fi
      sleep 1
    done

    echo; echo 'Inserting data...'

    curl -X DELETE $HOST/test_chef_cookbook/; echo

    curl -X POST $HOST/test_chef_cookbook/document/1 -d '{"title" : "Test 1", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test_chef_cookbook/document/2 -d '{"title" : "Test 2", "time" : "#{Time.now.utc}", "enabled" : false}'; echo
    curl -X POST $HOST/test_chef_cookbook/document/3 -d '{"title" : "Test 3", "time" : "#{Time.now.utc}", "enabled" : false}'; echo
    curl -X POST $HOST/test_chef_cookbook/document/4 -d '{"title" : "Test 4", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test_chef_cookbook/document/5 -d '{"title" : "Test 5", "time" : "#{Time.now.utc}", "enabled" : true} '; echo
    curl -X POST $HOST/test_chef_cookbook/_refresh; echo

    curl "$HOST/test_chef_cookbook/_search?q=Test&size=1&pretty"; echo
  EOS

end
