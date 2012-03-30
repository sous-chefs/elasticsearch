node.elasticsearch[:data][:devices].each do |device, params|
  # Format volume if format command is provided and volume is unformatted
  #
  bash "Format device #{device}" do

    code <<-EOS
      #{params[:format_command]}
    EOS

    only_if { params[:format_command] }
    not_if "dumpe2fs #{device}"

  end

  # Create directory with proper permissions
  #
  directory params[:mount_path] do
    owner node.elasticsearch[:user] and group node.elasticsearch[:user] and mode 0775
    recursive true
  end

  # Mount device to elasticsearch data path
  #
  mount params[:mount_path] do
    device  device
    fstype  params[:file_system]
    options params[:mount_options]
    action  [:mount, :enable]

    only_if { device }
  end

  # Ensure proper permissions
  #
  bash "Ensure proper permissions for #{params[:mount_path]}" do
    user    "root"
    code    <<-EOS
      chown -R #{node.elasticsearch[:user]}:#{node.elasticsearch[:user]} #{params[:mount_path]}
      chmod -R 775 #{params[:mount_path]}
    EOS
  end

end
