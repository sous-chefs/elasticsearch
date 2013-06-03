[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

Erubis::Context.send(:include, Extensions::Templates)

elasticsearch = "elasticsearch-#{node.elasticsearch[:version]}"

package "curl"

include_recipe "ark"

group node.elasticsearch[:user]

user node.elasticsearch[:user] do
  comment "ElasticSearch User"
  home    "#{node.elasticsearch[:dir]}/elasticsearch"
  shell   "/bin/bash"
  gid     node.elasticsearch[:user]
  supports :manage_home => false
  action  :create
end

# FIX: Work around the fact that Chef creates the directory even for `manage_home: false`
file "#{node.elasticsearch[:dir]}/elasticsearch" do
    action :delete
end

[ node.elasticsearch[:path][:conf], node.elasticsearch[:path][:logs], node.elasticsearch[:pid_path] ].each do |path|
  directory path do
    owner node.elasticsearch[:user]
    group node.elasticsearch[:user]
    mode 0755
    recursive true
  end
end

data_paths = node.elasticsearch[:path][:data].is_a?(Array) ? node.elasticsearch[:path][:data] : node.elasticsearch[:path][:data].split(',')

data_paths.each do |path|
  directory path.strip do
    owner node.elasticsearch[:user]
    group node.elasticsearch[:user]
    mode 0755
    recursive true
  end
end

template "/etc/init.d/elasticsearch" do
  source "elasticsearch.init.erb"
   mode 0755
end

ark "elasticsearch" do
  url   node.elasticsearch[:download_url]
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  version node.elasticsearch[:version]
  has_binaries ['bin/elasticsearch', 'bin/plugin']
  checksum node.elasticsearch[:checksum]

  notifies :start,   'service[elasticsearch]'
  notifies :restart, 'service[elasticsearch]'
end

bash "enable user limits" do
  user 'root'

  code <<-END.gsub(/^    /, '')
    echo 'session    required   pam_limits.so' >> /etc/pam.d/su
  END

  not_if { ::File.read("/etc/pam.d/su").match(/^session    required   pam_limits\.so/) }
end

bash "increase limits for the elasticsearch user" do
  user 'root'

  code <<-END.gsub(/^    /, '')
    echo '#{node.elasticsearch.fetch(:user, "elasticsearch")}     -    nofile    #{node.elasticsearch[:limits][:nofile]}'  >> /etc/security/limits.conf
    echo '#{node.elasticsearch.fetch(:user, "elasticsearch")}     -    memlock   #{node.elasticsearch[:limits][:memlock]}' >> /etc/security/limits.conf
  END

  not_if do
    file = ::File.read("/etc/security/limits.conf")
    file.include?("#{node.elasticsearch.fetch(:user, "elasticsearch")}     -    nofile    #{node.elasticsearch[:limits][:nofile]}") \
    &&           \
    file.include?("#{node.elasticsearch.fetch(:user, "elasticsearch")}     -    memlock   #{node.elasticsearch[:limits][:memlock]}")
  end
end

template "#{node.elasticsearch[:path][:conf]}/elasticsearch-env.sh" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  notifies :restart, 'service[elasticsearch]'
end

template "#{node.elasticsearch[:path][:conf]}/elasticsearch.yml" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  notifies :restart, 'service[elasticsearch]'
end

template "#{node.elasticsearch[:path][:conf]}/logging.yml" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  notifies :restart, 'service[elasticsearch]'
end

service "elasticsearch" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
