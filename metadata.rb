name             "elasticsearch"

maintainer       "karmi"
maintainer_email "karmi@karmi.cz"
license          "Apache"
description      "Installs and configures elasticsearch"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.markdown'))
version          "0.3.7"

depends 'ark'

recommends 'build-essential'
recommends 'xml'
recommends 'java'
recommends 'monit'

provides 'elasticsearch'
provides 'elasticsearch::data'
provides 'elasticsearch::ebs'
provides 'elasticsearch::aws'
provides 'elasticsearch::nginx'
provides 'elasticsearch::proxy'
provides 'elasticsearch::plugins'
provides 'elasticsearch::monit'
provides 'elasticsearch::search_discovery'
