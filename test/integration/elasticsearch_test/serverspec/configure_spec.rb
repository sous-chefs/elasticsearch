require_relative 'spec_helper'

# normal elasticsearch config with defaults

[
  '/usr/local/awesome/etc/elasticsearch',
  '/usr/local/awesome/var/data/elasticsearch',
  '/usr/local/awesome/var/log/elasticsearch',
].each do |p|
  describe file(p) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'foo' }
    it { should be_grouped_into 'bar' }
  end
end

describe file('/usr/local/awesome/etc/elasticsearch/elasticsearch-env.sh') do
  it { should be_file }
  it { should be_owned_by 'foo' }
  it { should be_grouped_into 'bar' }

  [
    'FOO=BAR',
    'PrintGCDetails'
  ].each do |line|
    its(:content) { should contain(/#{line}/) }
  end
end

describe file('/usr/local/awesome/etc/elasticsearch/elasticsearch.yml') do
  it { should be_file }
  it { should be_owned_by 'foo' }
  it { should be_grouped_into 'bar' }

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

describe file('/usr/local/awesome/etc/elasticsearch/logging.yml') do
  it { should be_file }
  it { should be_owned_by 'foo' }
  it { should be_grouped_into 'bar' }

  [
    'Configuration set by Chef',
    'es.logger.level: INFO',
    'rootLogger: INFO, console, file',
    'logger.action: INFO',
  ].each do |line|
    its(:content) { should match(/#{line}/)}
  end
end
