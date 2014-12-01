
default.elasticsearch[:newrelic][:dir]           = "#{node.elasticsearch[:dir]}/newrelic"
default.elasticsearch[:newrelic][:version]       = "3.12.0"
default.elasticsearch[:newrelic][:url]           = "https://repo1.maven.org/maven2/com/newrelic/agent/java/newrelic-agent/#{node.elasticsearch[:newrelic][:version]}/newrelic-agent-#{node.elasticsearch[:newrelic][:version]}.jar"
default.elasticsearch[:newrelic][:send_attrs]    = "true"
default.elasticsearch[:newrelic][:tracing]       = "false"
default.elasticsearch[:newrelic][:license]       = nil

default.elasticsearch[:newrelic][:templates][:yml] = "newrelic.yml.erb"
