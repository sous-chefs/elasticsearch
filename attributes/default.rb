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

default['elasticsearch']['checksums']['6.2.4']['debian'] = 'f9c889bf1e2e897a881f624dab6a4aa3be5ec1f9d65b6d115021095496351969'
default['elasticsearch']['checksums']['6.2.4']['rhel'] = '9c13e0fb8bc90b7bd6e09c8ba922c2d89c2183bb6161047ec6549c0cbcccee72'
default['elasticsearch']['checksums']['6.2.4']['tarball'] = '91e6f1ea1e1dd39011e7a703d2751ca46ee374665b08b0bfe17e0c0c27000e8e'

default['elasticsearch']['checksums']['6.3.0']['debian'] = '659c3f9a90ae5fe4568d5103de3bbd37e8a03143447118ee61fe72d514b8f4d6'
default['elasticsearch']['checksums']['6.3.0']['rhel'] = 'b6d7951b8ad72c06e7a23263227e1b90b8aa6e5d5ee798a6c849934516121109'
default['elasticsearch']['checksums']['6.3.0']['tarball'] = '0464127140820d82b24bd2830232131ea85bcd49267a8bc7365e4fa391dee2a3'

default['elasticsearch']['checksums']['6.3.1']['debian'] = '350cc95201814ec39b1c80bbb8329faf1dae20a3386b28b626144c6f67ced333'
default['elasticsearch']['checksums']['6.3.1']['rhel'] = '073e2bc52a82bc099cca1534391a057c6506dbcb06e849e24ff4d60187ade4b3'
default['elasticsearch']['checksums']['6.3.1']['tarball'] = '0b4d1c3c66894c9bf54284b53c1448d0e6def89a09c9fe4446e7167e51b8040e'

default['elasticsearch']['checksums']['6.4.0']['debian'] = 'dc7b4b5583ad4689f57369fb8bf8c9b708cfc278701c895762378b010460f658'
default['elasticsearch']['checksums']['6.4.0']['rhel'] = 'b7b8e6265ec4a3aec509fe1e3fb054e6c64256ce7f4ab64d1d5b1629b24883c2'
default['elasticsearch']['checksums']['6.4.0']['tarball'] = 'e9786efb5cecd12adee2807c7640ba9a1ab3b484d2e87497bb8d0b6df0e24f01'

default['elasticsearch']['checksums']['6.4.1']['debian'] = 'ba71dbe16bfb6111dbe7d49ffd447ed1092a754636b30214067d31ff3059e100'
default['elasticsearch']['checksums']['6.4.1']['rhel'] = '2d63f9814ff67edc5c8a8e247ed359a8ef7e23cfbe3a438041a72b44b0be09b2'
default['elasticsearch']['checksums']['6.4.1']['tarball'] = '6fce529465975b2cd2f5aef09b459006636e4b903e623fd6361ae9feeebf1542'

default['elasticsearch']['checksums']['6.4.2']['debian'] = '4ca2cc982db8e46743a98e2c3d678e60c24331b28f79ea424bb8a323e611f678'
default['elasticsearch']['checksums']['6.4.2']['rhel'] = '8987285d92d0d94f0e842e51ba8ed04fb9ad5e078cc68f63ef2ff8ca1986ad08'
default['elasticsearch']['checksums']['6.4.2']['tarball'] = '32a9c0305faed1cbd4e22c85a8c333ca2b6704f1d0006e92709fada10cec3f45'

default['elasticsearch']['checksums']['6.4.3']['debian'] = 'cbf62cf228e556ca89d94562cb747127da69f5a4a04198d1a19230455671d0d4'
default['elasticsearch']['checksums']['6.4.3']['rhel'] = 'd059c695eadefc26788106a7d3d4c6b300bc50ede36dfbcb04b1caa9211d5bff'
default['elasticsearch']['checksums']['6.4.3']['tarball'] = '861bc4d4188ce65df34a8876f104bbb2cddff3586990e57233e0847eb961b15e'

default['elasticsearch']['checksums']['6.5.0']['debian'] = '5fddd2759f7a96f884b0bfb863e04624ba50db39fa6455a87bef2b7bc4bff16e'
default['elasticsearch']['checksums']['6.5.0']['rhel'] = 'b78a6d3ddb59d086f0da28a2e25d9e5f0b5af61f0fd2898ce972f7ca9e84f961'
default['elasticsearch']['checksums']['6.5.0']['tarball'] = 'b158c02dddccc265d25855282015a7b09207c216be99c08114514ed283969b81'

default['elasticsearch']['checksums']['6.5.1']['debian'] = '7de183122a9dbb7b07ee56e18edf0365dc27e413a5962363b944a9aa63ffbb4a'
default['elasticsearch']['checksums']['6.5.1']['rhel'] = 'fc38dcce176a96665c0801054794f62d8a9a23c9f930919248cfbe2622c7255e'
default['elasticsearch']['checksums']['6.5.1']['tarball'] = '17cf2f58c7cbb36c4419a8143321660defe2c492b3a6eaa9a6dcd5e36347d124'

default['elasticsearch']['checksums']['6.5.2']['debian'] = '9cb0997dc6d2be16c988c0ee43ccafd19a8b2e757326af84f4cead40f74c614f'
default['elasticsearch']['checksums']['6.5.2']['rhel'] = 'ddab10c3be94fb89bc7057bdb20624b5e65e3ba8244d655e243119a5103e07c7'
default['elasticsearch']['checksums']['6.5.2']['tarball'] = 'b7b73b871957bdcff75d333eba8c1c6adf3731470f943b159365bde413e45dfc'

default['elasticsearch']['checksums']['6.5.3']['debian'] = '38b30461201fe8d126d124f04d961e7c037bea7a6fb9ca485c08e681d8d30456'
default['elasticsearch']['checksums']['6.5.3']['rhel'] = '2f3eb7682e06211061bea90a0314a515f0c4ef683f45c8e57bfb1dfb14679c3a'
default['elasticsearch']['checksums']['6.5.3']['tarball'] = 'cee4340dfaadf27d73ccaef5a8019e177021e1ffea3b7e622ca5ab9267725cac'

default['elasticsearch']['checksums']['6.5.4']['debian'] = 'c0a062ffb45f989cd3091c66f62605178c41c3735991d95506a6986a90924833'
default['elasticsearch']['checksums']['6.5.4']['rhel'] = 'aa4006f754bd1a0bfaa338ba40d93a1762917c1862951577c62b1f073026b5ba'
default['elasticsearch']['checksums']['6.5.4']['tarball'] = '762e25c036fa2e882cb7e91d83868fa15a1cad8549d279a8c5826a005bb31877'

default['elasticsearch']['checksums']['6.6.0']['debian'] = '0f34cd050bc2a6b4f3a4a8ea71755a03c638e1d929141424a246792e067534a9'
default['elasticsearch']['checksums']['6.6.0']['rhel'] = '8fdaaefa22cef3370bdf353df09bf07695d0e3764ac0c9b6ad8a1412076f9566'
default['elasticsearch']['checksums']['6.6.0']['tarball'] = '4993a17b88268a053042510404bcb808f86d6438fec458be4e0ef1c412681655'

default['elasticsearch']['checksums']['6.6.1']['debian'] = '505d5aae1c2ba66e36be41fe94ec9e4c444cbdd7926aaaa9392356a2c40d2102'
default['elasticsearch']['checksums']['6.6.1']['rhel'] = '3ba9ef562c951eccd070704db498dcf703f05b567d459f93f144e9189e1ee21a'
default['elasticsearch']['checksums']['6.6.1']['tarball'] = 'a4fd359facf03272013e3f2bffc846c1e1f8c60b7fb0daf856831f14947ed297'

default['elasticsearch']['checksums']['6.6.2']['debian'] = 'e5aa8b1449fb08b56ec5d9a52324cadd7439c29533fa7662badede051a9a9778'
default['elasticsearch']['checksums']['6.6.2']['rhel'] = '8a42533764f0332e09cb6d2ed2af02a641766d73a3669458b20fe37615047872'
default['elasticsearch']['checksums']['6.6.2']['tarball'] = 'f32d6fa73b466e29f30a5b6e0bcc6352a5508329f765c948c80c242ddfb97770'

default['elasticsearch']['checksums']['6.7.0']['debian'] = 'fdf31c8774b779cf5bf3c3f6e01371d11b5a3889ca3d9c3dbd2dc6142d96a633'
default['elasticsearch']['checksums']['6.7.0']['rhel'] = 'e09010ab7cbf5c81f8821e25a6617de29bcc658a3c79750e337471ef4711d8b4'
default['elasticsearch']['checksums']['6.7.0']['tarball'] = 'bed3587b892319d2e6b25d68c03930c95cf6d74210e3b368a638ca9f837a2315'

default['elasticsearch']['checksums']['6.7.1']['debian'] = '807223a278ffd29630f01a1c21ff268aa5b51ff36c66a2c56a7a8e275d102831'
default['elasticsearch']['checksums']['6.7.1']['rhel'] = '88b6f4de17ea943ac996648783cd07471ee37b894d17bf17939d9a0cedb30237'
default['elasticsearch']['checksums']['6.7.1']['tarball'] = '7be3f94882130c769e5a6b95dbccdc3cab9f101cbc68edfa661f7188c78f06e2'

default['elasticsearch']['checksums']['6.7.2']['debian'] = '8ad69655c22eabe94295ffb23434ae26ef4d839555ee9cb65261a6fe48e0dc12'
default['elasticsearch']['checksums']['6.7.2']['rhel'] = 'aabd389a4098fb99113907ae9665d454291dd32641cd33056f26ec713d017972'
default['elasticsearch']['checksums']['6.7.2']['tarball'] = 'd0ed638c825914d3c5fd8b34f69b5bcf9cfa5cf85af25145ea7a910ea8f708a9'

default['elasticsearch']['checksums']['6.8.0']['debian'] = 'cb5556c6b75ef2e2d3b0399625aaabae0bbd84229ffc08e8475fdbec1e1b66c0'
default['elasticsearch']['checksums']['6.8.0']['rhel'] = '702bde8def4d51788b49477225d345b693e34ede35c1fbf6fd1421860d3451f5'
default['elasticsearch']['checksums']['6.8.0']['tarball'] = '92c67cf48a145a60579857f190ed03a56e3ae42e599d0c84fed0747af866fffd'

default['elasticsearch']['checksums']['6.8.1']['debian'] = 'e7711bfb68e82f4538067da03634ef1937d71a1ab448d7d4eb3f20bc1c4854d1'
default['elasticsearch']['checksums']['6.8.1']['rhel'] = '4663f759cade5d1613842f86af3f78d064ce3c8e81de9615a353cc2eb413aed0'
default['elasticsearch']['checksums']['6.8.1']['tarball'] = 'ad33d463884acde2d8682cb46927f03603ea66133b84c12f53dc9edbc02447e3'

default['elasticsearch']['checksums']['6.8.2']['debian'] = '9e6b591bef75d042abb4888d914e37aab19bf8afb6eda9efaa6b270ac7edd151'
default['elasticsearch']['checksums']['6.8.2']['rhel'] = '3561e6c1bbac324448928e752b9d6c0d2a413c569993625f6dd255b343f61a6c'
default['elasticsearch']['checksums']['6.8.2']['tarball'] = '2dc3107475659dfd21afa74612a43d5ccbcf4942ab679e8e4e77167cafe27c94'

default['elasticsearch']['checksums']['7.0.0']['debian'] = '491d36af33bc896f8c44c46e1ed550e304220c9eedee991091864f5f3434e2f4'
default['elasticsearch']['checksums']['7.0.0']['rhel'] = '99ed1d22c128189ccb07c99babe7f437180e42c94af15782acf4b80d2520abc4'
default['elasticsearch']['checksums']['7.0.0']['tarball'] = '68deee5e9c961ad48cc83859970ac7a79029fe5f5e6de7e58ea0f7c7713f25ba'

default['elasticsearch']['checksums']['7.0.1']['debian'] = 'b84419e213539f5af2a0b3d73ebc11cf2da7e7061e6308e83333a9282bf920e4'
default['elasticsearch']['checksums']['7.0.1']['rhel'] = '52aba98ea0165492fa899ed8487af5cab10f5e452611995ebac31b5f44facd50'
default['elasticsearch']['checksums']['7.0.1']['tarball'] = '33866cbc61383d1ead01622ff54cadacec0b9fe81224af9b77104be614a56eca'

default['elasticsearch']['checksums']['7.1.0']['debian'] = '9cdb867ebfda5550590e2dc98e37020d9aa6bfd508b1b8be9f11f5683c807349'
default['elasticsearch']['checksums']['7.1.0']['rhel'] = '3facf261e9cbb88c8d792d2ff97e2aeb79c44d2df5fd83591ce4f2d5378eb7a4'
default['elasticsearch']['checksums']['7.1.0']['tarball'] = '91b4bd3722086e83dbe5ee7abf179de19b0cf9dc8a639438bde2721f184cc42e'

default['elasticsearch']['checksums']['7.1.1']['debian'] = '2ef15cb7e37d32b93c51ad537959831bd72cac2627f255d22cc574cec5de6aef'
default['elasticsearch']['checksums']['7.1.1']['rhel'] = '7950c7d97407d8948ca164d81866b389fe734e3ec775452a3e407e49cbd0d5ed'
default['elasticsearch']['checksums']['7.1.1']['tarball'] = 'd8cd7df1232d931b9ff8fda1e960d94b03db21b7f33162d6865ebcbe69a45f95'

default['elasticsearch']['checksums']['7.2.0']['debian'] = '1ff7b88c4bc38438a67719df499b17d4f7082a77eda89f39016f83414554ea95'
default['elasticsearch']['checksums']['7.2.0']['rhel'] = 'a854decb443631a0031a9492c1d5acbed00222381cb63cba68ae6d5deee3994c'
default['elasticsearch']['checksums']['7.2.0']['tarball'] = '24a2c31ff3ef34624752f266c39e40e84b103ab529dae7e062f1cb4b614cd1c5'

default['elasticsearch']['checksums']['7.2.1']['debian'] = '41f507b83fc49a3da5109afd18cc626ec5458acf567f00a80ac3f1c34b6d4b7f'
default['elasticsearch']['checksums']['7.2.1']['rhel'] = '96fdac0a8e6c74182d920b39e3f4830b722731a646126222c189e12a95302e6e'
default['elasticsearch']['checksums']['7.2.1']['tarball'] = 'd5d660895a39755ad6af16ec32cff5e2b645d5faf7150c69acc0fe013c604ae7'

default['elasticsearch']['checksums']['7.3.0']['debian'] = '72ae24cf0f5d97a307f35d116a41e1165e80f58f08b0ca4e6de3ec5228f06f9c'
default['elasticsearch']['checksums']['7.3.0']['rhel'] = 'f49dc809cf48369b70546f13dfb28b43e1a07387b681ca786c794762d52847ca'
default['elasticsearch']['checksums']['7.3.0']['tarball'] = '6cddb4d9a3c5e730f8e35e2155937c069d057129808ea135d31f0ed5f7f2ea22'
