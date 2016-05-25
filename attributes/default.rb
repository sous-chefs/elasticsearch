# elasticsearch version & install type
default['elasticsearch']['version'] = '2.3.3'
default['elasticsearch']['install_type'] = :package

# platform_family keyed download URLs
default['elasticsearch']['download_urls'] = {
  'debian' => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.deb',
  'rhel' => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.noarch.rpm',
  'tar' => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.tar.gz'
}

default['elasticsearch']['download_urls_v2'] = {
  'debian' => 'https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/%s/elasticsearch-%s.deb',
  'rhel' => 'https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/%s/elasticsearch-%s.rpm',
  'tar' => 'https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/%s/elasticsearch-%s.tar.gz'
}

# platform_family keyed download sha256 checksums
default['elasticsearch']['checksums']['1.4.5']['debian'] = '68dce951181e9802e94fd83b894f4b628394fc44bb01c77eb61fdbd1940d94b5'
default['elasticsearch']['checksums']['1.4.5']['rhel'] = '29b005c4148036556f78d6bd01a5e7c8e4ea60e2c20f82b63d8362ab46d83a19'
default['elasticsearch']['checksums']['1.4.5']['tar'] = 'dc28aa9e441cbc3282ecc9cb498bea219355887b102aac872bdf05d5977356e2'
default['elasticsearch']['checksums']['1.5.0']['debian'] = '15a02a2bea74da2330bb78718efb3a8f83a2b2e040a6ee859e100a6556981f36'
default['elasticsearch']['checksums']['1.5.0']['rhel'] = 'b72a9fb9a2c0471e8fe1a35373cdcfe39d29e72b7281bfccbdc32d03ee0eff70'
default['elasticsearch']['checksums']['1.5.0']['tar'] = 'acf572c606552bc446cceef3f8e93814a363ba0d215b323a2864682b3abfbe45'
default['elasticsearch']['checksums']['1.6.2']['debian'] = 'da22c2df44ade970c7d8ec346fd37a440ed40f9e73fb3427b9eacf44baf298c2'
default['elasticsearch']['checksums']['1.6.2']['rhel'] = '60c75a6f386bd729c6af2995af0a5290dd0ed6286673d435fc52620721815d91'
default['elasticsearch']['checksums']['1.6.2']['tar'] = 'b7ef3aae0a263c2312bd1a25b191c3c108c92d5413c3527d776587e582c518d0'
default['elasticsearch']['checksums']['1.7.1']['debian'] = '5832808f2a4c77de5af225db11da00138d9ea07a17f7b9212f4d2aac5317169d'
default['elasticsearch']['checksums']['1.7.1']['rhel'] = '9b083f441490b32f98f9bf654e5e8ddec885838128726691103cfda5068423bc'
default['elasticsearch']['checksums']['1.7.1']['tar'] = '86a0c20eea6ef55b14345bff5adf896e6332437b19180c4582a346394abde019'
default['elasticsearch']['checksums']['1.7.2']['debian'] = '791fb9f2131be2cf8c1f86ca35e0b912d7155a53f89c2df67467ca2105e77ec2'
default['elasticsearch']['checksums']['1.7.2']['rhel'] = 'c5410b88494d5cc9fdadf59353430b46c28e58eddc5c610ea4c4516eacc2fa09'
default['elasticsearch']['checksums']['1.7.2']['tar'] = '6f81935e270c403681e120ec4395c28b2ddc87e659ff7784608b86beb5223dd2'
default['elasticsearch']['checksums']['1.7.3']['debian'] = '52950c688cb3d6a13686753b4e8b1c80183e81174059924ee08b2df172afbb1c'
default['elasticsearch']['checksums']['1.7.3']['rhel'] = '2380343487ffafc6a7a834cf51d2abbfb7c5ad9d9d45301671adebf97abc632a'
default['elasticsearch']['checksums']['1.7.3']['tar'] = 'af517611493374cfb2daa8897ae17e63e2efea4d0377d316baa351c1776a2bca'
default['elasticsearch']['checksums']['1.7.4']['debian'] = 'f46a2892e454030d267f087db1be6bd9ae556bb1708a12cf94eeb4180951bf1f'
default['elasticsearch']['checksums']['1.7.4']['rhel'] = 'a3469fa93e05029ae4ba9dd7ddf80828095b850bc5764c24bae4dafc2346ef1f'
default['elasticsearch']['checksums']['1.7.4']['tar'] = '395f3417c26a6b36125f6a062c1129b454a961efea09151c692adc63562e5a94'
default['elasticsearch']['checksums']['1.7.5']['debian'] = '4e5a4d29f5fbd737d203e7049f2e18515c3443f9e01e193583e2b5c60779cc0f'
default['elasticsearch']['checksums']['1.7.5']['rhel'] = '4e0a4ff1ae76337308ebed977fb29c2f2d1251b2780f751676e3b18a1d7db00f'
default['elasticsearch']['checksums']['1.7.5']['tar'] = '0aa58947d66b487488e86059352deb7c6cab5da4accdff043cce9fed7c3d2fa7'
default['elasticsearch']['checksums']['2.0.0-rc1']['debian'] = '6ba92f96676932756ff7113f42d8946679e9be2144acece59bd79367568eb712'
default['elasticsearch']['checksums']['2.0.0-rc1']['rhel'] = '4dd4bdd1b4333f221bc5d2a2638bdc89282d57923842ce4c76607497abafb44d'
default['elasticsearch']['checksums']['2.0.0-rc1']['tar'] = 'cfd97bba0c49000a2799fffd359ec351f0ca7ef5f0a8c160920137db6b057784'
default['elasticsearch']['checksums']['2.0.0']['debian'] = 'f846cab2b7e99159650d38767249275c2fd5d3574fe700ef199cd1cb06ef28bf'
default['elasticsearch']['checksums']['2.0.0']['rhel'] = '6bd2d7840447836450d8781fffa9e296dfb257b523598c6e55433850e37feb25'
default['elasticsearch']['checksums']['2.0.0']['tar'] = 'b25f13f615337c2072964fd9fc5c7250f8a2a983b22198daf93548285d5d16df'
default['elasticsearch']['checksums']['2.0.1']['debian'] = '815a7b7d3bbd862c3ec136aa7bfb1adec272bdecdae45233d9ffdf61d307e86c'
default['elasticsearch']['checksums']['2.0.1']['rhel'] = '69957ef5ee6a142adf02c1065faa29bda7e2cf7f2d5c56edad4852b7f644345a'
default['elasticsearch']['checksums']['2.0.1']['tar'] = '7be4a6c717002057e422073ca8e957df8b4cb198bf2399a0d79f42121e34798b'
default['elasticsearch']['checksums']['2.1.0']['debian'] = '099fdeb7b3903ce8cea7d39b577ed6445b78b64d14dd2664fd2ca1e0896691dd'
default['elasticsearch']['checksums']['2.1.0']['rhel'] = 'a79c1985224c1b57479275794b258f4eba973e0b65f5c62b1c38e02738a1ce71'
default['elasticsearch']['checksums']['2.1.0']['tar'] = '8a4e85bcb506daa369651506af1cbc55c09fd7ff387d111142ae14d0a85d4d14'
default['elasticsearch']['checksums']['2.1.1']['debian'] = '097400b0b46c826c6a8be837739ade0c0c326b47d38ef54df7bd48de9e9e9995'
default['elasticsearch']['checksums']['2.1.1']['rhel'] = '22fc646aed2b6900116589a5712ac9324682470336bbbb025b4a607efb735e5a'
default['elasticsearch']['checksums']['2.1.1']['tar'] = 'ebd69c0483f20ba7e51caa9606d4e3ce5fe2667e1216c799f0cdbb815c317ce6'
default['elasticsearch']['checksums']['2.2.0']['debian'] = 'c97ac75303a7ba042c45adff74e27c3584d64d8e0f6f24c43afdcbff484b43d5'
default['elasticsearch']['checksums']['2.2.0']['rhel'] = '13fe3717e7761f23cd41a148a31ee49496cbdb45f44bfaeb3ba5538a41fdd79a'
default['elasticsearch']['checksums']['2.2.0']['tar'] = 'ed70cc81e1f55cd5f0032beea2907227b6ad8e7457dcb75ddc97a2cc6e054d30'
default['elasticsearch']['checksums']['2.2.1']['debian'] = 'cb89f880e03276624b3529506c9d2ed6b537968d1c819026e087117cd4c60c7c'
default['elasticsearch']['checksums']['2.2.1']['rhel'] = 'ddb5e1545e90b45e2b9495c35d5336a40fc63e09d8ac9cac73079888405df7f4'
default['elasticsearch']['checksums']['2.2.1']['tar'] = '7d43d18a8ee8d715d827ed26b4ff3d939628f5a5b654c6e8de9d99bf3a9b2e03'
default['elasticsearch']['checksums']['2.2.2']['debian'] = '5d44d4151430e5c87455f8efba41475a50a228131711a803b7ba7e271764bd9c'
default['elasticsearch']['checksums']['2.2.2']['rhel'] = '988d1b3c9aef94b8ea74daef14889690000c9fd6c80b0cf032039b4d26c252a6'
default['elasticsearch']['checksums']['2.2.2']['tar'] = 'c706db594f1feb5051d90697c6c412eadd60e00a9ec3b4f345a122801183af69'
default['elasticsearch']['checksums']['2.3.0']['debian'] = '2645e341587f636edaca1ee1380eeb76596d99b596bf17e03e2c37c697523efd'
default['elasticsearch']['checksums']['2.3.0']['rhel'] = '7469808bc64bca0b2e1a9fe258ff04ba4acde6c86d13a5cd19d623966fecfffd'
default['elasticsearch']['checksums']['2.3.0']['tar'] = 'd68482c7633f2986263bc5f11f93b8a58c54c6cf5e337b615446d0a7c6fdcd8b'
default['elasticsearch']['checksums']['2.3.1']['debian'] = 'ff22da40b60ae216761c7f6148e12760f34e0e51bc2198d5022934dc520b7d6c'
default['elasticsearch']['checksums']['2.3.1']['rhel'] = '841946dfe9220a4fdae7bbd491114a0eccbcc6d096bf4343d02e7c6e7abb704f'
default['elasticsearch']['checksums']['2.3.1']['tar'] = 'f0092e73038e0472fcdd923e5f2792e13692ea0f09ca034a54dd49b217110ebb'
default['elasticsearch']['checksums']['2.3.2']['debian'] = '3d474b0123ec8ad4ebfa089f8cde607033e6cbef28a6a0df318bdc3d2a546cd8'
default['elasticsearch']['checksums']['2.3.2']['rhel'] = '7bc84521921af8e43089c4fd64eced9eb68167d73fc14c102732f78750dfc607'
default['elasticsearch']['checksums']['2.3.2']['tar'] = '04c4d3913d496d217e038da88df939108369ae2e78eea29cb1adf1c4ab3a000a'
default['elasticsearch']['checksums']['2.3.3']['debian'] = 'fa90c6aefc5e82e0e19cb0ec546b9a64fec354ede201cf24658ddcfe01762d92'
default['elasticsearch']['checksums']['2.3.3']['rhel'] = '9aef1abe334d3143d8347144d69a35f449c5ecd8eebc3d7277f224d18679585a'
default['elasticsearch']['checksums']['2.3.3']['tar'] = '5fe0a6887432bb8a8d3de2e79c9b81c83cfa241e6440f0f0379a686657789165'
