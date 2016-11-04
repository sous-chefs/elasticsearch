# this is a test fixture used to test that the elasticsearch cookbook's
# resources, providers, and recipes can be used correctly from a wrapper

# create user with all non-default overriden options
elasticsearch_user 'foobar' do
  username 'elasticsearch'
  groupname 'bar'
  uid 1111
  gid 2222
  shell '/bin/sh'
  instance_name 'special_tarball_instance'
end

elasticsearch_install 'elasticsearch_s' do
  type 'tarball'
  dir '/usr/local/awesome'
  instance_name 'special_tarball_instance'
end

elasticsearch_configure 'my_elasticsearch' do
  path_home     '/usr/local/awesome/elasticsearch'
  path_conf     '/usr/local/awesome/etc/elasticsearch'
  path_data     '/usr/local/awesome/var/data/elasticsearch'
  path_logs     '/usr/local/awesome/var/log/elasticsearch'
  path_pid      '/usr/local/awesome/var/run'
  path_plugins  '/usr/local/awesome/elasticsearch/plugins'
  path_bin      '/usr/local/bin'

  logging(action: 'INFO')

  allocated_memory '123m'

  jvm_options %w(
    -XX:+UseParNewGC
    -XX:+UseConcMarkSweepGC
    -XX:CMSInitiatingOccupancyFraction=75
    -XX:+UseCMSInitiatingOccupancyOnly
    -XX:+HeapDumpOnOutOfMemoryError
    -XX:+PrintGCDetails
  )

  configuration('node.name' => 'crazy')
  action :manage
  instance_name 'special_tarball_instance'
end

elasticsearch_plugin 'x-pack' do
  instance_name 'special_tarball_instance'
end

elasticsearch_service 'elasticsearch-crazy' do
  # path_conf '/usr/local/awesome/etc/elasticsearch'
  # path_pid '/usr/local/awesome/var/run'
  instance_name 'special_tarball_instance'
  service_actions [:enable, :start]
end
