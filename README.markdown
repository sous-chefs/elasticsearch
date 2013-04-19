Description
-----------

This _Chef_ cookbook installs and configures the [_Elasticsearch_](http://www.elasticsearch.org)
search engine on a Linux compatible operating system.

-----
### Important Upgrade Notice ###

As of version 0.2.0, the Elasticsearch cookbook available from the Opscode community site is no longer
compatible with the previous version. If you are a user of the previous cookbook, please be aware that
there is no recommended upgrade process and you have to actively test the upgrade in your environment.
If you have questions, please leave a message in the comments section on the community site. Thanks!

-----

It requires a working _Java_ installation on the target node; add your preferred `java` cookbook to the node `run_list`.

The cookbook downloads the _elasticsearch_ tarball (via the [`ark`](http://github.com/bryanwb/chef-ark) provider),
unpacks and moves it to the directory you have specified in the node configuration (`/usr/local/elasticsearch` by default).

It installs a service which enables you to start, stop, restart and check status of the _elasticsearch_ process.

If you include the `elasticsearch::monit` recipe, it will create a configuration file for _Monit_,
which will check whether _elasticsearch_ is running, reachable by HTTP and the cluster is in the "green" state.
(Assumed you have included a compatible ["monit" cookbook](http://community.opscode.com/cookbooks/monit)
in your run list first.)

If you include the `elasticsearch::aws` recipe, the
[AWS Cloud Plugin](http://github.com/elasticsearch/elasticsearch-cloud-aws) will be installed on the node,
allowing you to use the _Amazon_ AWS-related features (node auto-discovery, etc).
Set your AWS credentials either in the "elasticsearch/aws" data bag, or directly in the role/node configuration.
Instead of using AWS access tokens, you can create the instance with a
[IAM role](http://aws.amazon.com/iam/faqs/#How_do_i_get_started_with_IAM_roles_for_EC2_instances).

If you include the `elasticsearch::data` and `elasticsearch::ebs` recipes, an EBS volume will be automatically
created, formatted and mounted so you can use it as a local gateway for _Elasticsearch_.
When the EBS configuration contains a `snapshot_id` value, it will be created with data from the corresponding snapshot. See the `attributes/data` file for more information.

If you include the `elasticsearch::proxy` recipe, it will configure the _Nginx_ server as
a reverse proxy for _Elasticsearch_, so you may access it remotely with HTTP authentication.
Set the credentials either in a "elasticsearch/users" data bag, or directly in the role/node configuration.


Usage
-----

For an overview, please read the tutorial on
[deploying elasticsearch with _Chef Solo_](http://www.elasticsearch.org/tutorials/deploying-elasticsearch-with-chef-solo/)
which uses this cookbook.

For _Chef Server_ based deployment, include the recipes you want to be executed in a
dedicated `elasticsearch` role, or in the node `run_list`.

Then, upload the cookbook to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife cookbook upload elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To enable the _Amazon_ AWS related features, include the `elasticsearch::aws` recipe.
You will need to configure the AWS credentials.

You may do that in the node configuration (with `knife node edit MYNODE` or in the _Chef Server_ console),
in a role with `override_attributes` declaration, but it is arguably most convenient to store
the information in an "elasticsearch" _data bag_:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    mkdir -p ./data_bags/elasticsearch
    echo '{
      "id" : "aws",
      "_default" : {
        "discovery" : { "type": "ec2" },

        "cloud"   : {
          "aws"     : { "access_key": "YOUR ACCESS KEY", "secret_key": "YOUR SECRET ACCESS KEY" },
          "ec2"     : { "security_group": "elasticsearch" }
        }
      }
    }' >> ./data_bags/elasticsearch/aws.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Do not forget to upload the data bag to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife data bag from file elasticsearch aws.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To use the EBS related features, use your preferred method of configuring node attributes,
or store the configuration in a data bag called `elasticsearch/data`:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~json
    {
      "elasticsearch": {
        // ...
        "data" : {
          "devices" : {
            "/dev/sda2" : {
              "file_system"      : "ext3",
              "mount_options"    : "rw,user",
              "mount_path"       : "/usr/local/var/data/elasticsearch/disk1",
              "format_command"   : "mkfs.ext3",
              "fs_check_command" : "dumpe2fs",
              "ebs"            : {
                "size"                  : 250,         // In GB
                "delete_on_termination" : true,
                "type"                  : "io1",
                "iops"                  : 2000
              }
            }
          }
        }
      }
    }
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usually, you will restrict the access to _Elasticsearch_ with firewall rules. However, it's convenient
to be able to connect to the _Elasticsearch_ cluster from `curl` or a HTTP client, or to use a
management tool such as [_BigDesk_](http://github.com/lukas-vlcek/bigdesk) or
[_Paramedic_](http://github.com/karmi/elasticsearch-paramedic).
(Don't forget to set the `node.elasticsearch[:nginx][:allow_cluster_api]` attribute to _true_
if you want to access these tools via the proxy.)

To enable authorized access to _elasticsearch_, you need to include the `elasticsearch::proxy` recipe,
which will install, configure and run [_Nginx_](http://nginx.org) as a reverse proxy, allowing users with proper
credentials to connect.

Usernames and passwords may be stored in a data bag `elasticsearch/users`:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    mkdir -p ./data_bags/elasticsearch
    echo '{
      "id" : "users",
      "_default" : {
        "users" : [
          {"username" : "USERNAME", "password" : "PASSWORD"},
          {"username" : "USERNAME", "password" : "PASSWORD"}
        ]
      }
    }
    ' >> ./data_bags/elasticsearch/users.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Again, do not forget to upload the data bag to the _Chef_ server:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife data bag from file elasticsearch users.json
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After you have configured the node and uploaded all the information to the _Chef_ server,
run `chef-client` on the node(s):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    knife ssh name:elasticsearch* 'sudo chef-client'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please note that all data bags _must_ have attributes enclosed in an environment
(use the `_default` environment), as suggested by the Chef
[documentation](http://docs.opscode.com/chef/essentials_data_bags.html#use-data-bags-with-environments).

Testing with Vagrant
--------------------

The cookbook comes with a [`Vagrantfile`](https://github.com/elasticsearch/cookbook-elasticsearch/blob/master/Vagrantfile), which allows you to test-drive the installation and configuration with
[_Vagrant_](http://vagrantup.com/), a tool for building virtualized infrastructures.

First, make sure, you have both _VirtualBox_ and _Vagrant_
[installed](http://docs.vagrantup.com/v1/docs/getting-started/index.html).

Then, clone this repository into an `elasticsearch` directory on your development machine:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    git clone git://github.com/elasticsearch/cookbook-elasticsearch.git elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Switch to the cloned repository:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    cd elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Install the neccessary gems with [Bundler](http://gembundler.com):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    gem install bundler
    bundle install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All the required third-party cookbooks will be automatically installed via the
[_Berkshelf_](http://berkshelf.com) integration. If you want to install them
locally (eg. to inspect them), use the `berks` command:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    berks install --path ./tmp/cookbooks
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `Vagrantfile` supports four Linux distributions:

* Ubuntu Precise 64 bit
* Ubuntu Lucid 32 bit
* Ubuntu Lucid 64 bit
* CentOS 6 32 bit

Use the `vagrant status` command for more information.

We will use the [_Ubuntu Precise 64_](http://vagrantup.com/v1/docs/boxes.html) box for the purpose of this demo.
You may want to test-drive this cookbook on a different distribution; check out the available boxes at <http://vagrantbox.es> or build a custom one with [_veewee_](https://github.com/jedi4ever/veewee/tree/master/templates).

Launch the virtual machine (it will download the box unless you already have it):

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    time CHEF=latest bundle exec vagrant up precise64
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The machine will be started and automatically provisioned with
[_chef-solo_](http://vagrantup.com/v1/docs/provisioners/chef_solo.html).
(Note: You may substitute _latest_ with a specific Chef version.
Set the `UPDATE` environment variable to update packages on the machine as well.)

You'll see _Chef_ debug messages flying by in your terminal, downloading, installing and configuring _Java_,
_Nginx_, _Elasticsearch_, and all the other components.
The process should take less then 10 minutes on a reasonable machine and internet connection.

After the process is done, you may connect to _elasticsearch_ via the _Nginx_ proxy from the outside:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    curl 'http://USERNAME:PASSWORD@33.33.33.10:8080/test_chef_cookbook/_search?pretty&q=*'
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Of course, you should connect to the box with SSH and check things out:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~bash
    bundle exec vagrant ssh precise64

    ps aux | grep elasticsearch
    service elasticsearch status --verbose
    curl http://localhost:9200/_cluster/health?pretty
    sudo monit status elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The cookbook provides test cases in the `files/default/tests/minitest/` directory,
which are executed as a part of the _Chef_ run in _Vagrant_
(via the [Minitest Chef Handler](https://github.com/calavera/minitest-chef-handler) support).
They check the basic installation mechanics, populate the `test_chef_cookbook` index
with some sample data, perform a simple search, etc.


Repository
----------

http://github.com/elasticsearch/cookbook-elasticsearch

License
-------

Author: Karel Minarik (<karmi@elasticsearch.com>) and [contributors](http://github.com/elasticsearch/cookbook-elasticsearch/graphs/contributors)

License: Apache
