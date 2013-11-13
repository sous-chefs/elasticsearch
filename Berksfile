metadata

%w{ apt java build-essential }.each do |cookbook|
  cookbook cookbook, git: 'git@github.com:Tapjoy/chef.git',
    rel: "cookbooks/#{cookbook}"
end

cookbook 'minitest-handler', git: 'git://github.com/btm/minitest-handler-cookbook.git'
