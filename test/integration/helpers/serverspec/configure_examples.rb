require_relative 'spec_helper'

shared_examples_for 'elasticsearch configure' do |args = {}|
  path_conf = args[:path_conf] || '/etc/elasticsearch'
  path_data = args[:path_data] || '/var/lib/elasticsearch'
  path_logs = args[:path_logs] || '/var/log/elasticsearch'
  path_sysconfig = args[:path_sysconfig] || (rhel? ? '/etc/sysconfig/elasticsearch' : '/etc/default/elasticsearch')

  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'

  expected_config = args[:config] || [
    'cluster.name: elasticsearch',
    'node.name: .+',
    'path.conf: \/.+',
    'path.data: \/.+',
    'path.logs: \/.+',
  ]

  expected_environment = args[:env] || [
    'ES_PATH_CONF=.+',
    'DATA_DIR=.+',
    'ES_GROUP=.+',
    'ES_HOME=.+',
    'ES_STARTUP_SLEEP_TIME=.+',
    'ES_USER=.+',
    'LOG_DIR=.+',
    'MAX_LOCKED_MEMORY=.+',
    'MAX_MAP_COUNT=.+',
    'MAX_OPEN_FILES=.+',
    'PID_DIR=.+',
    'RESTART_ON_UPGRADE=.+',
  ]

  expected_jvm_options = args[:jvmopts] || [
    'server',
    'HeapDumpOnOutOfMemoryError',
    'java.awt.headless=true',
  ]

  describe file(path_conf) do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by expected_user } unless package?
    it { should be_grouped_into expected_group } unless package?
  end

  [path_data, path_logs].each do |p|
    describe file(p) do
      it { should be_directory }
      it { should be_mode 755 }
      it { should be_owned_by expected_user } unless package?
      it { should be_grouped_into expected_group } unless package?
    end
  end

  describe file(path_sysconfig) do
    it { should be_file }
    it { should be_mode 644 }

    expected_environment.each do |line|
      its(:content) { should contain(/#{line}/) }
    end
  end

  describe file("#{path_conf}/elasticsearch.yml") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    expected_config.each do |line|
      its(:content) { should contain(/#{line}/) }
    end
  end

  describe file("#{path_conf}/jvm.options") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    expected_jvm_options.each do |line|
      its(:content) { should contain(/#{line}/) }
    end
  end

  describe file("#{path_conf}/log4j2.properties") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by expected_user }
    it { should be_grouped_into expected_group }

    its(:content) { should match(/logger.action.name = org.elasticsearch.action/) }
  end
end
