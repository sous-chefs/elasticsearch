newrelic_jar_path="#{node[:elasticsearch][:newrelic][:dir]}/newrelic.jar"
newrelic_conf_path="#{node[:elasticsearch][:newrelic][:dir]}/newrelic.yml"

directory node[:elasticsearch][:newrelic][:dir] do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  action :create
end

remote_file newrelic_jar_path do
  source node[:elasticsearch][:newrelic][:url]
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  action :create
end

template "newrelic.yml" do
  path   newrelic_conf_path
  source node.elasticsearch[:newrelic][:templates][:yml]
  owner  node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0644

  notifies :restart, 'service[elasticsearch]' unless node.elasticsearch[:skip_restart]
end

execute %Q|echo 'ES_JAVA_OPTS="\$ES_JAVA_OPTS -javaagent:#{newrelic_jar_path} -Dnewrelic.config.file=#{newrelic_conf_path} -Dnewrelic.logfile=#{node[:elasticsearch][:path][:logs]}/newrelic_agent.log "' >> "#{node.elasticsearch[:path][:conf]}/elasticsearch-env.sh"
