cookbook_path = '/tmp/elasticsearch-cookbooks'

desc "install dependencies using Berkshelf"
task :install_deps do 
  system("berks install --shims #{cookbook_path}")
end

