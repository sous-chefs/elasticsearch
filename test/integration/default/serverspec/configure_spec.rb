require_relative 'spec_helper'

# normal elasticsearch config with defaults

[
  '/usr/local/etc/elasticsearch',
  '/usr/local/var/data/elasticsearch',
  '/usr/local/var/log/elasticsearch',
].each do |p|
  describe file(p) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end
end

describe file('/usr/local/etc/elasticsearch/elasticsearch-env.sh') do
  it { should be_file }
  it { should be_owned_by 'elasticsearch' }
  it { should be_grouped_into 'elasticsearch' }

  [
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
  ].each do |line|
    its(:content) { should contain(/#{line}/) }
  end
end

describe file('/usr/local/etc/elasticsearch/elasticsearch.yml') do
  it { should be_file }
  it { should be_owned_by 'elasticsearch' }
  it { should be_grouped_into 'elasticsearch' }

  [
    'cluster.name: elasticsearch',
    'node.name: .+',
    'path.conf: \/.+',
    'path.data: \/.+',
    'path.logs: \/.+',

  ].each do |line|
    its(:content) { should contain(/#{line}/) }
  end
end

describe file('/usr/local/etc/elasticsearch/logging.yml') do
  it { should be_file }
  it { should be_owned_by 'elasticsearch' }
  it { should be_grouped_into 'elasticsearch' }

  [
    'Configuration set by Chef'
  ].each do |line|
    its(:content) { should match(/#{line}/)}
  end
end
