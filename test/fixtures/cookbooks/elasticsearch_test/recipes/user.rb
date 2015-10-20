elasticsearch_user 'deleteme' do
  groupname 'foo'
end

elasticsearch_user 'deleteme' do
  action :remove
end
