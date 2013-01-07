# Add Monit configuration file via the `monitrc` definition
#
begin
  monitrc "elasticsearch" do
    pidfile "#{node.elasticsearch[:pid_path]}/#{node.elasticsearch[:node_name].to_s.gsub(/\W/, '_')}.pid"
    template_cookbook "elasticsearch"
  end
rescue Exception => e
  Chef::Log.error "The 'monit' recipe is not included in the node run_list or the 'monitrc' resource is not defined"
  raise e
end
