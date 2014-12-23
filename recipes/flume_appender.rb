logback_appender_path  = "#{node.elasticsearch[:dir]}/elasticsearch/lib/logback-flume-appender.jar"
common_appender_path   = "#{node.elasticsearch[:dir]}/elasticsearch/lib/common-flume-appender.jar"

remote_file logback_appender_path do
  source node[:flume][:logging][:flume_appender_logback][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end

remote_file common_appender_path do
  source node[:flume][:logging][:flume_appender_common][:url]
  owner node.flume[:user]
  group node.flume[:user]
  action :create
end
