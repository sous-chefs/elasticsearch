maintainer       "karmi"
maintainer_email "karmi@karmi.cz"
license          "MIT License"
description      "Installs and configures elasticsearch on Amazon EC2"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recommends 'java'
recommends 'monit'
recommends 'nginx'

provides 'elasticsearch'
provides 'service[elasticsearch]'

