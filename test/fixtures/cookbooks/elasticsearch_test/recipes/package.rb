# this is a test fixture used to test that the elasticsearch cookbook's
# resources, providers, and recipes can be used correctly from a wrapper

# create user with all non-default overriden options
elasticsearch_user 'foobar' do
  groupname 'bar'
  username 'elasticsearch' # can't override this in systemd, so can't test!
  uid 1111
  gid 2222
  shell '/bin/sh'
  instance_name 'special_package_instance'
end

# we're going to test both types on a single system!
elasticsearch_install 'elasticsearch_p' do
  type 'package'
  instance_name 'special_package_instance'
end

elasticsearch_configure 'my_elasticsearch' do
  logging(action: 'INFO')

  allocated_memory '123m'

  jvm_options %w(
    -server
    -Djava.awt.headless=true
    -XX:+UseParNewGC
    -XX:+UseConcMarkSweepGC
    -XX:CMSInitiatingOccupancyFraction=75
    -XX:+UseCMSInitiatingOccupancyOnly
    -XX:+HeapDumpOnOutOfMemoryError
    -XX:+PrintGCDetails
  )

  configuration('node.name' => 'arbitrary_name')
  # plugin_dir '/usr/local/awesome/elasticsearch-1.7.3/plugins'
  action :manage
  instance_name 'special_package_instance'
end

elasticsearch_plugin 'x-pack' do
  instance_name 'special_package_instance'
end

elasticsearch_service 'elasticsearch-crazy' do
  instance_name 'special_package_instance'
  service_actions [:enable, :start]
end
