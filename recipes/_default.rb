
if node.elasticsearch[:method] == "pkg"
  #mandatory path in pkg method (done by packaging)
  #Need to force it in all conditions. So I use the force_override 
  node.force_override[:elasticsearch][:dir]         = "/usr/share/"
  node.force_override[:elasticsearch][:bindir]      = "/usr/share/elasticsearch/bin"
  node.force_override[:elasticsearch][:path][:conf] = "/etc/elasticsearch"
  node.force_override[:elasticsearch][:nginx][:passwords_file] = "#{node.elasticsearch[:path][:conf]}/passwords"
  node.force_override[:elasticsearch][:pid_path] = "/var/run/"
  node.force_override[:elasticsearch][:pid_file] = "/var/run/$NAME.pid"
end

