# Download and add GPG repo key
# Add repo entries to package tool

case node[:platform]
when "debian","ubuntu"
    bash "install_gpg_key" do
        user "root"
        code "wget -O - " + node.elasticsearch[:repo_gpgkey] + "| apt-key add -"
    end
    template "/etc/apt/sources.list.d/elasticsearch.list" do
        source "elasticsearch.list.erb"
        mode 00644
    end
    bash "run_apt_get_update" do
        user "root"
        code "apt-get update"
    end
when "centos","redhat","fedora"
    bash "install_gpg_key" do
        user "root"
        #environment {"GPG_KEY_URL" => node.elasticsearch[:repo_gpgkey]}
        code "rpm --import " + node.elasticsearch[:repo_gpgkey]
    end
    template "/etc/yum.repos.d/elasticsearch.repo" do
        source "elasticsearch.repo.erb"
        mode 00644
    end
end

# Install java (as elastic search package don't disclose it as dependency)

case node[:platform]
    when "debian","ubuntu"
        package "default-jre" do
            options "--force-yes"
            action :install
        end
    when "centos","redhat","fedora"
        package "java-1.7.0-openjdk" do
            action :install
        end
end

# Install elasticsearch from repo
package "elasticsearch" do
    case node[:platform]
    when "debian","ubuntu"
        options "--force-yes"
    end
    action :install
end

# Enable and start service

service "elasticsearch" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end
