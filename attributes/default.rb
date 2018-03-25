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

default['elasticsearch']['checksums']['6.0.1']['debian'] = 'ebe6c14638a4909155fe409fb46a7f52bcd3ad2151bfd2f400ab6f8f61c45b3e'
default['elasticsearch']['checksums']['6.0.1']['rhel'] = '25e7a8b152ea85886688398f48bc995d47cd2a12a7d98487748c6166f0732b85'
default['elasticsearch']['checksums']['6.0.1']['tarball'] = 'efaf32aba41e1b7fd086639c0f062c39e1f28b360a78d5c2b8deed797a4c5c57'

default['elasticsearch']['checksums']['6.1.0']['debian'] = '102be4439b1df7f7606003b3c839dbf69d3827c3e996563c98c0d54560b4fc16'
default['elasticsearch']['checksums']['6.1.0']['rhel'] = 'ebac1b4e1fc8ae3f7266cba93ef113510cba13435ada2c92480506d16cf6b865'
default['elasticsearch']['checksums']['6.1.0']['tarball'] = 'c879fe2698635a2f132db4a02d84f657bc0ccdb5c5f68dda5102f9b2afa508d7'

default['elasticsearch']['checksums']['6.1.1']['debian'] = '8b6e65dce742c733aa61da24f9c8c0d4d4b7f53ae11d7f4168e98b5a0ed58b45'
default['elasticsearch']['checksums']['6.1.1']['rhel'] = '9820555c72b61b54686bcf0697cdabace28b02315bb5a156999495a16b103d5a'
default['elasticsearch']['checksums']['6.1.1']['tarball'] = '0cadc90c2ab1bd941e3965eef96fbc2c08b12b832ae81f5882e81505333b74b6'

default['elasticsearch']['checksums']['6.1.2']['debian'] = '64d8bd2bd895904bb91daff656764b10da93531f2011c94d7c779124e53dd5f5'
default['elasticsearch']['checksums']['6.1.2']['rhel'] = 'bfa6809ac94bda92a4ec1bf601c8266f82a4c7842a7702da4dede8f7d5c6a2ec'
default['elasticsearch']['checksums']['6.1.2']['tarball'] = '9c0eae0bdab78c59dac0ba3a9c054e6785dc0f5ce4666e284f42010a326abc0f'

default['elasticsearch']['checksums']['6.2.0']['debian'] = 'eeb974247ea4360e37798888a5f49227d5ea33e11665a060c9b01b25140f9554'
default['elasticsearch']['checksums']['6.2.0']['rhel'] = '869b6506a35aad6b6d82fe987130402cef9b40c33ff7d98eeaa186eb2a628964'
default['elasticsearch']['checksums']['6.2.0']['tarball'] = '7be4a6580aca7d17b2fe1a1e589aa0a005b6240ef5dce6a5288a56f68021f8f6'

default['elasticsearch']['checksums']['6.2.1']['debian'] = '2b145aa11bccd2fe99256b9715ff665fe091b62fc699bc77cd07c528dcbf2391'
default['elasticsearch']['checksums']['6.2.1']['rhel'] = '47b97342821cbd1805826a18a7559a59bd045b9aef66e45c3b293b02aeaaeba8'
default['elasticsearch']['checksums']['6.2.1']['tarball'] = '0ccd13c53d23dcb2aea5c0f71dcbe81283e1e31d6ae5d40dec03656852cb468b'

default['elasticsearch']['checksums']['6.2.2']['debian'] = 'e0a694dcbbac993a4039978ca60e6c05b0bd78ec7eef20a1e95b98979579a47a'
default['elasticsearch']['checksums']['6.2.2']['rhel'] = 'a31277bb89b93da510bf40261882f710a448178ec5430c7a78ac77e91f733cf9'
default['elasticsearch']['checksums']['6.2.2']['tarball'] = 'b26e3546784b39ce3eacc10411e68ada427c5764bcda3064e9bb284eca907983'

default['elasticsearch']['checksums']['6.2.3']['debian'] = 'b54a1b685656a1424d4956e48daed923752fc268b79bb1b8616cc91f6a78e3bb'
default['elasticsearch']['checksums']['6.2.3']['rhel'] = 'd513a6f82436914c35e774529686e5fdfed1af77264e39228e5d64eee22c78ce'
default['elasticsearch']['checksums']['6.2.3']['tarball'] = '01dd8dec5f0acf04336721e404bf4d075675a3acae9f2a9fdcdbb5ca11baca76'
