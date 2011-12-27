Description
-----------

This cookbook installs and configures the [_elasticsearch_](http://www.elasticsearch.org) search engine and database.

It requires a working Java installation on the target node. The cookbook downloads the _elasticsearch_ tarball from Github, unpacks and moves it to the directory you have specified in the node configuration (`/usr/local` by default).

It also installs a service which enables you to start, stop, restart and check status of _elasticsearch_.

If your node has the "monit" recipe available, it will also create a configuration file for _Monit_,
which will check whether _elasticsearch_ is running, reachable by HTTP and the cluster is in the “green” state.

If you include the "elasticsearch::plugin_aws" recipe, the appropriate plugin will be installed for you,
allowing you to use Amazon AWS features: node auto-discovery and S3/EBS persistence.
You may set your AWS credentials either in a `elasticsearch/aws` data bag,
or directly in the node configuration.

You may want to include the "elasticsearch::proxy_nginx" recipe, which will configure Nginx as
a reverse proxy so you may access _elasticsearch_ remotely with HTTP Authentication. (Be sure to
include a "nginx" cookbook in your node stup as well.)

The cookbook also provides the "elasticsearch::test" recipe, which populates the `test_chef_cookbook`
index with some sample data to check if the installation, the S3 persistence, etc is working.


Usage
-----

Include the "elasticsearch" recipe on the node you wish _elasticsearch_ being installed.

To enable the Amazon AWS related features, include the "elasticsearch::plugin_aws" recipe.
You will need to configure the credentials and other things for AWS.

You may do that in the node konfiguration (with `knife node edit MYNODE` or at the Chef console),
but probably more convenient is to store the information in a "elasticsearch" data bag:

    mkdir -p ./data_bags/elasticsearch
    echo '{ 
      "id" : "aws",
      "discovery" : { "type": "ec2" },

      "gateway" : {
        "type"    : "s3",
        "s3"      : { "bucket": "YOUR BUCKET NAME" }
      },

      "cloud"   : {
        "aws"     : { "access_key": "YOUR ACCESS KEY", "secret_key": "YOUR SECRET ACCESS KEY" },
        "ec2"     : { "security_group": "elasticsearch" }
      }
    }' >> ./data_bags/elasticsearch/aws.json

Do not forget to upload the data bag to the _Chef_ server:

    knife data bag from file elasticsearch aws.json

Usually, you will restrict the access to _elasticsearch_ from the outside. However, it's convenient to be able
to connect to the _elasticsearch_ cluster from `curl` or HTTP client, or to inspect management tool such as
[_bigdesk_](http://github.com/lukas-vlcek/bigdesk).

To enable authorized access to _elasticsearch_, you may want to include the "elasticsearch::proxy_nginx" recipe,
which will install, configure and run [_Nginx_](http://nginx.org/) as a reverse proxy, allowing users with proper
credentials. As with AWS, you may store the usernames and passwords in the node configuration, but also in
a data bag item:

    mkdir -p ./data_bags/elasticsearch
    echo '{
      "id" : "users",
      "users" : [
        {"username" : "USERNAME", "password" : "PASSWORD"},
        {"username" : "USERNAME", "password" : "PASSWORD"}
      ]
    }
    ' >> ./data_bags/elasticsearch/users.json

Again, do not forget to upload the data bag to the _Chef_ server.

After you have configured the node and uploaded all the information to the _Chef_ server, run `chef-client` on the node(s):

    knife ssh name:elasticsearch* 'sudo su - root -c "chef-client"'


Cookbook Organization
---------------------

* `attributes/default.rb`: version, paths, memory and naming settings for the node
* `attributes/plugin_aws.rb`: Amazon AWS related node configuration
* `attributes/proxy_nginx.rb`: _Nginx_ node settings
* `templates/default/elasticsearch.init.erb`: service init script
* `templates/default/elasticsearch.yml.erb`: main _elasticsearch_ configuration file
* `templates/default/elasticsearch-env.sh.erb`: environment variables needed by the _Java Virtual Machine_ and _elasticsearch_
* `templates/default/elasticsearch_proxy_nginx.conf.erb`: the reverse proxy configuration
* `templates/default/elasticsearch.monitrc.erb`: _Monit_ configuration.

License
-------

Author: Karel Minarik (<karmi@karmi.cz>)

MIT LICENSE
