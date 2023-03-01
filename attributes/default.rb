# empty settings (populate these for the elasticsearch::default recipe)
# see the resources or README.md to see what you can pass here.
default['elasticsearch']['user'] = {}
default['elasticsearch']['install'] = {}
default['elasticsearch']['configure'] = {}
default['elasticsearch']['service'] = {}
default['elasticsearch']['plugin'] = {}

# platform_family keyed download URLs
default['elasticsearch']['download_urls'] = {
  'debian' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.deb',
  'rhel' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.rpm',
  'tarball' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.tar.gz',
}

default['elasticsearch']['download_urls_v7'] = {
  'debian' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s-amd64.deb',
  'rhel' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s-x86_64.rpm',
  'tarball' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s-linux-x86_64.tar.gz',
}

# platform_family keyed download sha256 checksums
default['elasticsearch']['checksums']['7.8.0']['debian'] = 'e566a88e15d8f85cf793c8f971b51eeae6465a0aa73f968ae4b1ee6aa71e4c20'
default['elasticsearch']['checksums']['7.8.0']['rhel'] = 'e6202bba2bd8644d23dcbef9ad7780c847dfe4ee699d3dc1804f6f62eed59c2d'
default['elasticsearch']['checksums']['7.8.0']['tarball'] = '37c317efaacf33a1bae250a59e822864750fddd8caf08c4b6a6c235ffa5f47e8'
