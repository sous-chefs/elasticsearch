# Encoding: utf-8
require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'
