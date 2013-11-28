include_recipe "elasticsearch::_default"


options=<<-END 
-Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.port=#{node.elasticsearch[:jmx_config][:port]}
END
if node[:elasticsearch][:jmx_config][:hostname_fqdn]
	options << "-Djava.rmi.server.hostname=#{node.fqdn}\n"
else
	options << "-Djava.rmi.server.hostname=#{node.ipaddress}\n"
end

users = data_bag(node[:elasticsearch][:jmx_config][:users])
if users == nil
  options << "-Dcom.sun.management.jmxremote.authenticate=false\n"
else
  options << "-Dcom.sun.management.jmxremote.authenticate=true\n"
  options << "-Dcom.sun.management.jmxremote.access.file=#{node[:elasticsearch][:path][:conf]}/access_jmx\n"
  options << "-Dcom.sun.management.jmxremote.password.file=#{node[:elasticsearch][:path][:conf]}/passwd_jmx\n"
  #We must now recover all jmx_users from data_bag to put in the node
  node.default[:elasticsearch][:jmx_users]=[]

  users.each do |key|
    luser=data_bag_item(node[:elasticsearch][:jmx_config][:users], key)
    jmx_user={ :id => luser["id"], :passwd => luser["password"], :access => luser["access"] }
    node.default[:elasticsearch][:jmx_users].push(jmx_user)
  end
  
  p node.default[:elasticsearch][:jmx_users]
  template "#{node[:elasticsearch][:path][:conf]}/access_jmx" do
    source "access.jmx.erb"
    owner node[:elasticsearch][:user]
    mode "600"
    variables({
      :lusers => node.default[:elasticsearch][:jmx_users]
    })

    
  end
  template "#{node[:elasticsearch][:path][:conf]}/passwd_jmx" do
    source "passwd.jmx.erb"
    owner node[:elasticsearch][:user]
    mode "600"
    variables({
      :lusers => node.default[:elasticsearch][:jmx_users]
    })
    notifies :restart, "service[elasticsearch]", :immediately

  end
end

#Add a predefined env_options
options << node.default["elasticsearch"]["env_options"]

node.default["elasticsearch"]["env_options"] << options
node.default["elasticsearch"]["jmx"]=true


