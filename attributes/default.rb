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

# platform_family keyed download sha256 checksums
default['elasticsearch']['checksums']['6.0.0']['debian'] = '28f38779156387c1db274d8d733429e574b54b4f518da6f0741f6276f8229939'
default['elasticsearch']['checksums']['6.0.0']['rhel'] = '823fa8aa24e9948dea30f0a468f0403b34a62180e02ed752443d5964334c29a1'
default['elasticsearch']['checksums']['6.0.0']['tarball'] = '0420e877a8b986485244f603770737e9e4e47186fdfa1093768a11e391e3d9f4'
