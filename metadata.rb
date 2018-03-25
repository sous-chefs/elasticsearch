# Encoding: utf-8
name             'elasticsearch'
maintainer       'Karel Minarik'
maintainer_email 'karel.minarik@elasticsearch.org'
license          'Apache 2.0'
description      'Installs and configures Elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.0.0'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'fedora'
supports 'redhat'
supports 'ubuntu'

depends 'apt'
depends 'yum'
depends 'chef-sugar'
depends 'ark'

issues_url       'https://github.com/elastic/cookbook-elasticsearch/issues'
source_url       'https://github.com/elastic/cookbook-elasticsearch'

chef_version '>= 12.5' if respond_to?(:chef_version)
