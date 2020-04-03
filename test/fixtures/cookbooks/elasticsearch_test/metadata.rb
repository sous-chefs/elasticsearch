# Encoding: utf-8
name             'elasticsearch_test'
maintainer       'Karel Minarik'
maintainer_email 'karel.minarik@elasticsearch.org'
license          'Apache-2.0'
description      'A wrapper cookbook for use in testing that elasticsearch cookbook works well with wrappers calling it'
version          '0.1.0'

depends 'apt'
depends 'yum'
depends 'chef-sugar'
depends 'elasticsearch'
