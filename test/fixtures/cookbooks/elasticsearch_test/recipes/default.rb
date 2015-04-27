# this is a test fixture used to test that the elasticsearch cookbook's
# resources, providers, and recipes can be used correctly from a wrapper

# create user with all non-default overriden options
elasticsearch_user 'foobar' do
  groupname 'bar'
  username 'foo'
  uid 1111
  gid 2222
  shell '/bin/sh'
  homedir '/usr/local/myhomedir'
end

elasticsearch_user 'deleteme'

elasticsearch_user 'deleteme' do
  action :remove
end

# we're going to test both types on a single system!
elasticsearch_install 'elasticsearch_p' do
  type :package
end

elasticsearch_install 'elasticsearch_s' do
  type :source
  dir '/usr/local/awesome'
  owner 'foo'
  group 'bar'
end

elasticsearch_configure 'my_elasticsearch' do
  dir '/usr/local/awesome'
  user 'foo'
  group 'bar'
  logging({:"action" => 'INFO'})

  java_rmi_server_hostname 'localhost'
  jmx true

  allocated_memory '123m'
  thread_stack_size '512k'

  env_options '-DFOO=BAR'
  gc_settings <<-CONFIG
                -XX:+UseParNewGC
                -XX:+UseConcMarkSweepGC
                -XX:CMSInitiatingOccupancyFraction=75
                -XX:+UseCMSInitiatingOccupancyOnly
                -XX:+HeapDumpOnOutOfMemoryError
                -XX:+PrintGCDetails
              CONFIG

  configuration ({
    'node.name' => 'crazy'
  })

  action :manage
end

elasticsearch_plugin 'mobz/elasticsearch-head' do
  plugin_dir '/usr/local/awesome/elasticsearch-1.5.0/plugins'
end

elasticsearch_service 'elasticsearch-crazy' do
  node_name 'crazy'
  path_conf '/usr/local/awesome/etc/elasticsearch'
  pid_path '/usr/local/awesome/var/run'
  user 'foo'
  group 'bar'
end
