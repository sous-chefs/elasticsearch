include_recipe "elasticsearch::nginx"

template "#{node.elasticsearch[:nginx][:dir]}/conf.d/elasticsearch_proxy.conf" do
  owner node.elasticsearch[:nginx][:user]
  group node.elasticsearch[:nginx][:user]
  mode 0755
  notifies :reload, 'service[nginx]'
end

ruby_block "add users to passwords file" do
  block do
    require 'webrick/httpauth/htpasswd'
    @htpasswd = WEBrick::HTTPAuth::Htpasswd.new(node.elasticsearch[:nginx][:passwords_file])

    node.elasticsearch[:nginx][:users].each do |u|
      Chef::Log.debug "Adding user '#{u['username']}' to #{node.elasticsearch[:nginx][:passwords_file]}\n"
      @htpasswd.set_passwd( 'Elasticsearch', u['username'], u['password'] )
    end

    @htpasswd.flush
  end

  not_if { node.elasticsearch[:nginx][:users].empty? }
end

file node.elasticsearch[:nginx][:passwords_file] do
  owner node.elasticsearch[:nginx][:user] 
  group node.elasticsearch[:nginx][:user] 
  mode 0755
  action :touch
end
