node[:elasticsearch][:plugins].each do | name, config |
  install_plugin name, config
end
