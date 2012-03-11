Description
-----------

This cookbook installs and configures the [_elasticsearch_](http://www.elasticsearch.org) search engine and database.

It requires a working Java installation on the target node. The cookbook downloads the _elasticsearch_ tarball from Github, unpacks and moves it to the directory you have specified in the node configuration (`/usr/local` by default).

It also installs a service which enables you to start, stop, restart and check status of _elasticsearch_.

If your node has the `monit` recipe available, it will also create a configuration file for _Monit_,
which will check whether _elasticsearch_ is running, reachable by HTTP and the cluster is in the “green” state.

If you include the `elasticsearch::plugin_aws` recipe, the appropriate plugin will be installed for you,
allowing you to use Amazon AWS features: node auto-discovery and S3/EBS persistence.
You may set your AWS credentials either in a “elasticsearch/aws” data bag,
or directly in the node configuration.

You may want to include the `elasticsearch::proxy_nginx` recipe, which will configure Nginx as
a reverse proxy so you may access _elasticsearch_ remotely with HTTP Authentication. (Be sure to
include a `nginx` cookbook in your node setup as well.)

The cookbook also provides the `elasticsearch::test` recipe, which populates the `test_chef_cookbook`
index with some sample data to check if the installation, the S3 persistence, etc is working.


Usage
-----

Include the `elasticsearch` recipe in the `run_list` of a node. Then, upload the cookbook to the _Chef_ server:

```bash
    knife cookbook upload elasticsearch
```

To enable the Amazon AWS related features, include the `elasticsearch::plugin_aws` recipe.
You will need to configure the AWS credentials, bucket names, etc.

You may do that in the node configuration (with `knife node edit MYNODE` or at the _Chef_ console),
but it is probably more convenient to store the information in a "elasticsearch" _data bag_:

```bash
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
```

Do not forget to upload the data bag to the _Chef_ server:

```bash
    knife data bag from file elasticsearch aws.json
```

Usually, you will restrict the access to _elasticsearch_. However, it's convenient to be able to connect
to the _elasticsearch_ cluster from `curl` or HTTP client, or to use a management tool such as
[_bigdesk_](http://github.com/lukas-vlcek/bigdesk).

To enable authorized access to _elasticsearch_, you may want to include the `elasticsearch::proxy_nginx` recipe,
which will install, configure and run [_Nginx_](http://nginx.org/) as a reverse proxy, allowing users with proper
credentials to connect.

As with AWS, you may store the usernames and passwords in the node configuration, but also in a data bag item:

```bash
    mkdir -p ./data_bags/elasticsearch
    echo '{
      "id" : "users",
      "users" : [
        {"username" : "USERNAME", "password" : "PASSWORD"},
        {"username" : "USERNAME", "password" : "PASSWORD"}
      ]
    }
    ' >> ./data_bags/elasticsearch/users.json
```

Again, do not forget to upload the data bag to the _Chef_ server.

After you have configured the node and uploaded all the information to the _Chef_ server, run `chef-client` on the node(s):

```bash
    knife ssh name:elasticsearch* 'sudo su - root -c "chef-client"'
```


Testing with Vagrant
--------------------

The cookbook comes with a [`Vagrantfile`](https://github.com/karmi/cookbook-elasticsearch/blob/master/Vagrantfile),
allowing you to test-drive the installation and configuration with [_Vagrant_](http://vagrantup.com/),
the tool for building virtualized development infrastructure.

First, make sure, you have both _VirtualBox_ and _Vagrant_
[installed](http://vagrantup.com/docs/getting-started/index.html).

Then, clone this repository into `elasticsearch`, somewhere on your development machine:

```bash
    git clone git://github.com/karmi/cookbook-elasticsearch.git elasticsearch
```

Switch to the cloned repository:

```bash
   cd elasticsearch
```

Download the required cookbooks (unless you already have them in `~/cookbooks`):

```bash
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1184/original/apt.tgz   | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/631/original/java.tgz   | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1098/original/vim.tgz   | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1413/original/nginx.tgz | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/915/original/monit.tgz | tar xz -C tmp/cookbooks
```

We will use the [_Ubuntu Lucid 64_](http://vagrantbox.es/2/) box, but you may want to test-drive this cookbook on a different
OS, of course. Check out the available boxes at <http://vagrantbox.es>.

Now, launch the virtual machine with _Vagrant_ (it will download the box unless you already have it):

```bash
    vagrant up
```

The machine will be started and automatically provisioned with 
[_chef-solo_](http://vagrantup.com/docs/provisioners/chef_solo.html). You'll see _Chef_ debug messages flying by in your terminal, installing and configuring _Java_, _Nginx_, _elasticsearch_, etc. The process should take less then 15 minutes.

After the process is done, you may connect to _elasticsearch_ via the _Nginx_ proxy:

```bash
    open 'http://USERNAME:PASSWORD@33.33.33.10:8080/test_chef_cookbook/_search?q=*'
```

Of course, you should connect to the box with SSH and check things out:

```bash
    vagrant ssh
    ps aux | grep elasticsearch
    service elasticsearch status --verbose
    curl http://localhost:9200/_cluster/health?pretty
```


Cookbook Organization
---------------------

* `attributes/default.rb`: version, paths, memory and naming settings for the node
* `attributes/plugin_aws.rb`: _Amazon Web Services_ settings
* `attributes/proxy_nginx.rb`: _Nginx_ settings
* `templates/default/elasticsearch.init.erb`: service init script
* `templates/default/elasticsearch.yml.erb`: main _elasticsearch_ configuration file
* `templates/default/elasticsearch-env.sh.erb`: environment variables needed by the _Java Virtual Machine_ and _elasticsearch_
* `templates/default/elasticsearch_proxy_nginx.conf.erb`: the reverse proxy configuration
* `templates/default/elasticsearch.conf.erb`: _Monit_ configuration file


License
-------

Author: Karel Minarik (<karmi@karmi.cz>)

MIT LICENSE
