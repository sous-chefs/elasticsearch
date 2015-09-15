# elasticsearch version & install type
default['elasticsearch']['version'] = '1.7.2'
default['elasticsearch']['install_type'] = 'tarball'

# platform_family keyed download URLs
default['elasticsearch']['download_urls']['debian'] = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.deb"
default['elasticsearch']['download_urls']['rhel'] = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.noarch.rpm"
default['elasticsearch']['download_urls']['tar'] = "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-%s.tar.gz"

# platform_family keyed download checksums
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
