# we're going to test both types on a single system!
elasticsearch_install 'elasticsearch_p' do
  type :package
end

elasticsearch_install 'elasticsearch_s' do
  type :source
  dir '/usr/local/awesome'
  owner 'foo'
  group 'bar'
end
