# elasticsearch version & install type
default['elasticsearch']['version'] = '5.0.0'
default['elasticsearch']['install_type'] = :package

# platform_family keyed download URLs
default['elasticsearch']['download_urls'] = {
  'debian' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.deb',
  'rhel' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.rpm',
  'tar' => 'https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-%s.tar.gz'
}

# platform_family keyed download sha256 checksums
default['elasticsearch']['checksums']['5.0.0']['debian'] = '0a4f8842a1f7d7bd3015118298284383efcd4c25f9591c46bb5ab68189815268'
default['elasticsearch']['checksums']['5.0.0']['rhel'] = 'fb502a9754f2162f27590125aecc6b68fa999738051d8f230c4da4ed6deb8d62'
default['elasticsearch']['checksums']['5.0.0']['tar'] = 'a866534f0fa7428e980c985d712024feef1dee04709add6e360fc7b73bb1e7ae'
