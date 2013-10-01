
options=<<-END 
-Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.port=#{node.elasticsearch[:jmx_config][:port]}
END
if node[:elasticsearch][:jmx_config][:hostname_fqdn]
	options << "-Djava.rmi.server.hostname=#{node.fqdn}"
else
	options << "-Djava.rmi.server.hostname=#{node.ipaddress}"
end

node[:elasticsearch][:env_options] << options

node[:elasticsearch][:jmx]=true


