# create user with all non-default overriden options
elasticsearch_user 'foo bar baz' do
  groupname 'bar'
  username 'foo'
  uid 1111
  gid 2222
  shell '/bin/sh'
  homedir '/usr/local/myhomedir'
end

elasticsearch_user 'deleteme'

elasticsearch_user 'deleteme' do
  action :remove
end
