require_relative 'spec_helper'

shared_examples_for 'elasticsearch configure' do |args = {}|
  dir = args[:dir] || (package? ? '/usr/share/elasticsearch' : '/usr/local')
  path_conf = args[:path_conf] || (package? ? '/etc/elasticsearch' : "#{dir}/etc/elasticsearch")
  path_data = args[:path_data] || (package? ? '/var/lib/elasticsearch' : "#{dir}/var/data/elasticsearch")
  path_logs = args[:path_logs] || (package? ? '/var/log/elasticsearch' : "#{dir}/var/log/elasticsearch")

  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'

  expected_config = args[:config] || [
    'cluster.name: elasticsearch',
    'node.name: .+',
    'path.conf: \/.+',
    'path.data: \/.+',
    'path.logs: \/.+'
  ]

  expected_environment = args[:env] || [
    'ES_HOME=.+',
    'ES_CLASSPATH=.+',
    'ES_HEAP_SIZE=[0-9]+m',
    'ES_JAVA_OPTS=',
    '-server',
    '-Djava.net.preferIPv4Stack=true',
    '-Des.config=\/.+',
    '-Xss256k',
    'UseParNewGC',
    'UseConcMarkSweepGC',
    'CMSInitiatingOccupancyFraction=75',
    'UseCMSInitiatingOccupancyOnly',
    'HeapDumpOnOutOfMemoryError'
  ]

  [path_conf, path_data, path_logs].each do |p|
    describe file(p) do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by expected_user }
      it { should be_grouped_into expected_group }
    end
  end

  describe file("#{path_conf}/elasticsearch.in.sh") do
    it { should be_file }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    expected_environment.each do |line|
      its(:content) { should contain(/#{line}/) }
    end
  end

  describe file("#{path_conf}/elasticsearch.yml") do
    it { should be_file }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    expected_config.each do |line|
      its(:content) { should contain(/#{line}/) }
    end
  end

  describe file("#{path_conf}/logging.yml") do
    it { should be_file }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    [
      'Configuration set by Chef',
      'es.logger.level: INFO',
      'rootLogger: INFO, console, file'
    ].each do |line|
      its(:content) { should match(/#{line}/) }
    end
  end
end
