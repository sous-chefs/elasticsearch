# Encoding: utf-8
name             'elasticsearch'
maintainer       'Karel Minarik'
maintainer_email 'karel.minarik@elasticsearch.org'
license          'Apache 2.0'
description      'Installs and configures Elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url       'https://github.com/elastic/cookbook-elasticsearch/issues' if respond_to?(:issues_url)
source_url       'https://github.com/elastic/cookbook-elasticsearch' if respond_to?(:source_url)
version          '2.3.1'

depends 'apt'
depends 'yum'
depends 'chef-sugar'
depends 'ark'
