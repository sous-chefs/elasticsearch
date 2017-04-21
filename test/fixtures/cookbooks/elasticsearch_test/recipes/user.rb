begin
  user = find(:elasticsearch_user => 'deleteme')
rescue
  user = elasticsearch_user 'deleteme'
end

user.groupname 'foo'
user.action [:create, :remove]
