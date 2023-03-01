name             'elasticsearch'
maintainer       'Karel Minarik'
maintainer_email 'karel.minarik@elasticsearch.org'
license          'Apache-2.0'
description      'Installs and configures Elasticsearch'
version          '4.3.1'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'

depends 'apt'
depends 'yum'
depends 'ark'

issues_url       'https://github.com/elastic/cookbook-elasticsearch/issues'
source_url       'https://github.com/elastic/cookbook-elasticsearch'

chef_version '>= 15.3'
