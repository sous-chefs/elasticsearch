# Encoding: utf-8
name             'elasticsearch'
maintainer       'karmi'
maintainer_email 'karmi@karmi.cz'
license          'Apache 2.0'
description      'Installs/Configures elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

depends 'apt'
depends 'yum'
depends 'chef-sugar'
depends 'curl'
