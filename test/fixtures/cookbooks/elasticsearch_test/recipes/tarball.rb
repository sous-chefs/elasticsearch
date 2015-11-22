# this is a test fixture used to test that the elasticsearch cookbook's
# resources, providers, and recipes can be used correctly from a wrapper

# create user with all non-default overriden options
elasticsearch_user 'foobar' do
  username 'foo'
  groupname 'bar'
  uid 1111
  gid 2222
  shell '/bin/sh'
  instance_name 'special_tarball_instance'
end

elasticsearch_install 'elasticsearch_s' do
  type :tarball
  dir tarball: '/usr/local/awesome'
  instance_name 'special_tarball_instance'
end

elasticsearch_configure 'my_elasticsearch' do
  path_home     tarball: '/usr/local/awesome/elasticsearch'
  path_conf     tarball: '/usr/local/awesome/etc/elasticsearch'
  path_data     tarball: '/usr/local/awesome/var/data/elasticsearch'
  path_logs     tarball: '/usr/local/awesome/var/log/elasticsearch'
  path_pid      tarball: '/usr/local/awesome/var/run'
  path_plugins  tarball: '/usr/local/awesome/elasticsearch/plugins'
  path_bin      tarball: '/usr/local/bin'

  logging(:action => 'INFO')

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

  configuration('node.name' => 'crazy')
  action :manage
  instance_name 'special_tarball_instance'
end

elasticsearch_plugin 'head' do
  url 'mobz/elasticsearch-head'
  instance_name 'special_tarball_instance'
end

elasticsearch_service 'elasticsearch-crazy' do
  # path_conf '/usr/local/awesome/etc/elasticsearch'
  # path_pid '/usr/local/awesome/var/run'
  instance_name 'special_tarball_instance'
  service_actions [:enable, :start]
end
