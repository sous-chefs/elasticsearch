default.elasticsearch[:repo_gpgkey] = "http://packages.elasticsearch.org/GPG-KEY-elasticsearch"
case node[:platform]
when "ubuntu","debian"
    default.elasticsearch[:repo_url] = "http://packages.elasticsearch.org/elasticsearch/0.90/debian"
when "centos","redhat","fedora"
    default.elasticsearch[:repo_url] = "http://packages.elasticsearch.org/elasticsearch/0.90/centos"
end
