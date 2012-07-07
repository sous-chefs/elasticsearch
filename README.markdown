Description
-----------

This cookbook installs and configures the [_elasticsearch_](http://www.elasticsearch.org) search engine/database.

It requires a working _Java_ installation on the target node; add your preferred `java` cookbook to the node `run_list`.

The cookbook downloads the _elasticsearch_ tarball from GitHub (via the [`ark`](http://github.com/bryanwb/chef-ark) provider),
unpacks and moves it to the directory you have specified in the node configuration (`/usr/local/elasticsearch` by default).

It installs a service which enables you to start, stop, restart and check status of the _elasticsearch_ process.

If your node has the `monit` recipe in its `run_list`, it will also create a configuration file for _Monit_,
which will check whether _elasticsearch_ is running, reachable by HTTP and the cluster is in the "green" state.

If you include the `elasticsearch::plugin_aws` recipe, the
[AWS Cloud Plugin](http://github.com/elasticsearch/elasticsearch-cloud-aws) will be installed on the node,
allowing you to use the _Amazon_ AWS features: node auto-discovery and S3 gateway.
You may set your AWS credentials either in the "elasticsearch/aws" data bag,
or directly in the node configuration.

You may want to include the `elasticsearch::proxy` recipe, which will configure _Nginx_ as
a reverse proxy for _elasticsearch_, so you may access it remotely with HTTP Authentication.
(Be sure to include a `nginx` cookbook in your node setup in this case.)

The cookbook also provides a test case in the `files/default/tests/minitest/` directory,
which can be executed as a part of the Chef run
(via the [Minitest Chef Handler](https://github.com/calavera/minitest-chef-handler) support).
It checks the basic installation mechanics, populates the `test_chef_cookbook` index
with some sample data and performs a simple search.


Usage
-----

Include the `elasticsearch` recipe in the `run_list` of a node. Then, upload the cookbook to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife cookbook upload elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To enable the _Amazon_ AWS related features, include the `elasticsearch::plugin_aws` recipe.
You will need to configure the AWS credentials, bucket names, etc.

You may do that in the node configuration (with `knife node edit MYNODE` or in the _Chef Server_ console),
but it is arguably more convenient to store the information in an "elasticsearch" _data bag_:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
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
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Do not forget to upload the data bag to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife data bag from file elasticsearch aws.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usually, you will restrict the access to _elasticsearch_ with firewall rules. However, it's convenient
to be able to connect to the _elasticsearch_ cluster from `curl` or a HTTP client, or to use a management tool such as
[_BigDesk_](http://github.com/lukas-vlcek/bigdesk) or [_Paramedic_](http://github.com/karmi/elasticsearch-paramedic).

To enable authorized access to _elasticsearch_, you need to include the `elasticsearch::proxy` recipe,
which will install, configure and run [_Nginx_](http://nginx.org) as a reverse proxy, allowing users with proper
credentials to connect.

As with AWS, you may store the usernames and passwords in the node configuration, but also in a data bag item:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    mkdir -p ./data_bags/elasticsearch
    echo '{
      "id" : "users",
      "users" : [
        {"username" : "USERNAME", "password" : "PASSWORD"},
        {"username" : "USERNAME", "password" : "PASSWORD"}
      ]
    }
    ' >> ./data_bags/elasticsearch/users.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Again, do not forget to upload the data bag to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife data bag from file elasticsearch users.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After you have configured the node and uploaded all the information to the _Chef_ server, run `chef-client` on the node(s):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife ssh name:elasticsearch* 'sudo chef-client'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Testing with Vagrant
--------------------

The cookbook comes with a [`Vagrantfile`](https://github.com/karmi/cookbook-elasticsearch/blob/master/Vagrantfile),
allowing you to test-drive the installation and configuration with [_Vagrant_](http://vagrantup.com/),
a tool for building virtualized development infrastructures.

First, make sure, you have both _VirtualBox_ and _Vagrant_
[installed](http://vagrantup.com/docs/getting-started/index.html).

Then, clone this repository into a `elasticsearch` directory on your development machine:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    git clone git://github.com/karmi/cookbook-elasticsearch.git elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Switch to the cloned repository:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
   cd elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the neccessary gems:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
   bundle install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You need to download the required third-party cookbooks (unless you already have them in `~/cookbooks`).

You can install the cookbooks manually by simply downloading them:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1184/original/apt.tgz   | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1421/original/java.tgz  | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1098/original/vim.tgz   | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1413/original/nginx.tgz | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/915/original/monit.tgz  | tar xz -C tmp/cookbooks
    curl -# -L -k http://s3.amazonaws.com/community-files.opscode.com/cookbook_versions/tarballs/1631/original/ark.tgz   | tar xz -C tmp/cookbooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The easiest way is to use the bundled [_Berkshelf_](http://berkshelf.com) support -- the cookbooks will be automatically
installed and mounted in the virtual machine. (You can use the `berks install --path ./tmp/cookbooks` command as well.)

The `Vagrantfile` supports four Linux distributions so far:

* Ubuntu Precise 64 bit
* Ubuntu Lucid 32 bit
* Ubuntu Lucid 64 bit
* CentOS 6 32 bit

Use the `vagrant status` command for more information.

We will use the [_Ubuntu Precise 64_](http://vagrantup.com/v1/docs/boxes.html) box for the purpose of this demo.
You may want to test-drive this cookbook on a different distribution; check out the available boxes at <http://vagrantbox.es>.

Launch the virtual machine with _Vagrant_ (it will download the box unless you already have it):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    time vagrant up precise64
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The machine will be started and automatically provisioned with
[_chef-solo_](http://vagrantup.com/v1/docs/provisioners/chef_solo.html).

You'll see _Chef_ debug messages flying by in your terminal, downloading, installing and configuring _Java_, _Nginx_,
_elasticsearch_, and all the other components.
The process should take about 15 minutes on a reasonable machine and internet connection.

After the process is done, you may connect to _elasticsearch_ via the _Nginx_ proxy from the outside:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    curl 'http://USERNAME:PASSWORD@33.33.33.10:8080/test_chef_cookbook/_search?pretty&q=*'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Of course, you should connect to the box with SSH and check things out:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    vagrant ssh precise64

    ps aux | grep elasticsearch
    service elasticsearch status --verbose
    curl http://localhost:9200/_cluster/health?pretty
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Cookbook Organization
---------------------

* `attributes/default.rb`: version, paths, memory and naming settings for the node
* `attributes/plugin_aws.rb`: AWS settings
* `attributes/proxy.rb`: _Nginx_ settings
* `templates/default/elasticsearch.init.erb`: service init script
* `templates/default/elasticsearch.yml.erb`: main _elasticsearch_ configuration file
* `templates/default/elasticsearch-env.sh.erb`: environment variables needed by the _Java Virtual Machine_ and _elasticsearch_
* `templates/default/elasticsearch_proxy.conf.erb`: the reverse proxy configuration
* `templates/default/elasticsearch.conf.erb`: _Monit_ configuration file
* `files/default/tests/minitest`: integration tests

License
-------

Author: Karel Minarik (<karmi@karmi.cz>)

MIT LICENSE
