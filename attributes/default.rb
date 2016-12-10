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
  'tarball' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.tar.gz'
}

# platform_family keyed download sha256 checksums
default['elasticsearch']['checksums']['5.1.1']['debian'] = 'c8a38990a24b558fb9c65492034caa00044e638d0ede6d440b00cb4eacb46d1d'
default['elasticsearch']['checksums']['5.1.1']['rhel'] = '94cd4d9a3c307e4128bfae159e5c18a149e522cb8ab51089e969d9f1ed830805'
default['elasticsearch']['checksums']['5.1.1']['tarball'] = 'cd45bafb1f74a7df9bad12c77b7bf3080069266bcbe0b256b0959ef2536e31e8'
