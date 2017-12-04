# Frequently asked questions

## Versions and Support

### Does this cookbook install [Java](https://www.java.com/en/)? What version?

This cookbook requires java, but does not provide it. Please install Java before using any recipe in this cookbook. Please also note that Elasticsearch itself has [specific minimum Java version requirements](https://www.elastic.co/guide/en/elasticsearch/reference/current/setup.html#jvm-version). We recommend [this cookbook](https://github.com/agileorbit-cookbooks/java) to install Java.

### What version of [Chef](https://www.chef.io/) does this cookbook require/support?

This cookbook follows the [recommended Chef community cookbook policy](https://github.com/chef/chef-rfc/blob/master/rfc092-dependency-update-cadence.md#cookbook-and-ecosystem-tooling-support) regarding Chef support; specifically, we support at least the last 6 months of Chef Client versions. We explicitly don't support anything less than Chef 12.5 and greater. We run CI as well as testing with chefspec and test-kitchen.

### What versions of [Elasticsearch](https://www.elastic.co/products/elasticsearch) does this cookbook support?

This cookbook is being written and tested to support Elasticsearch 6.x and greater. If you must have a cookbook that works with older versions of Elasticsearch, please test and then pin to a specific, older `major.minor` version of this cookbook and only leave the patch release to float. Older versions can be found via [Git tags](https://github.com/elastic/cookbook-elasticsearch/tags) or on [Chef Supermarket](https://supermarket.chef.io/cookbooks/elasticsearch). We also maintain bugfix branches for major released lines (0.x, 1.x, 2.x, 3.x) of this cookbook so that we can still release fixes for older cookbooks. Previous versions of this cookbook may be found using the git tags on this repository.

## How do I...

### How do I set the JVM heap size?

The [allocated_memory](https://github.com/elastic/cookbook-elasticsearch/blob/master/libraries/provider_configure.rb#L115-L119) parameter controls this.

### How should I discover other Elasticsearch nodes?

We recommend using [chef search](https://docs.chef.io/chef_search.html) in your wrapper cookbook, or using one of the contributing plugins that leverage cloud-specific features (e.g. `discovery-ec2`).

### How do I create EBS block devices or other block devices?

We recommend [the aws cookbook](https://github.com/chef-cookbooks/aws).

### How do I upgrade Elasticsearch in place?

Upgrading Elasticsearch in place is not recommended, and generally not supported by this cookbook. We strongly recommend you pin versions of Elasticsearch and spin up new servers to migrate to a new version, one node at a time. This cookbook does not generally set destructive options like asking the package manager to overwrite configuration files without prompting, either.

See also: https://github.com/elastic/cookbook-elasticsearch/issues/533

### How do I override settings in the systemd unit file?

If you'd like to modify the system unit file, you have two supported options:
1. [Specify a different source template ](https://github.com/elastic/cookbook-elasticsearch/blob/master/libraries/resource_service.rb#L26-L27)
1. Use an override file (see "Unit File Load Path" in the [systemd documentation](https://www.freedesktop.org/software/systemd/man/systemd.unit.html))

Typically, the override file should go in something like: `/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf`.

Check out https://github.com/elastic/elasticsearch/issues/23848#issuecomment-290836681 for more information.

### How do I avoid running various elasticsearch_* resource?

If you're running this cookbook inside docker, or manually performing some of the steps to install, configure, or run Elasticsearch, you will notice immediately that this cookbook complains about any missing resources. In order to provide the cookbook will appropriate settings (some resources _need_ information from others, e.g. configuring elasticsearch requires knowing where it is installed), you should simply use the missing resource but specify `action :none`. See #573 for more information

For example, `elasticsearch_plugin` needs to source the environment file used by `elasticsearch_service` in order to be sure it uses the same settings. If you're running in a container, you may not want to use a service. Therefore, do something like this:

```
elasticsearch_service 'elasticsearch' do
  args '-d'  # let other resources know we need to use -d, but don't touch the service
  action :none
end
```

## Specific errors and messages

### Elasticsearch complains about data paths on startup

Per 5.3.1 release notes, Elasticsearch now fails to start if you provide default.path.data and an array of path.data in order to correct a bug from 5.3.0 that merged the default into the array instead of ignoring it. However, default values for cookbook attributes that set those values are also preventing ES from starting, even though path.data isn't an array.

TL;DR -- you should upgrade and get the bugfix (of the original bugfix). See https://github.com/elastic/cookbook-elasticsearch/issues/563 for more information.

### Chef::Exceptions::Package: Installed package is newer than candidate package

You may be trying to downgrade Elasticsearch, or the newer package has gone missing from their repos. Depending on what you'd like to do next, you may [provide package_options arguments](https://github.com/elastic/cookbook-elasticsearch/blob/master/libraries/resource_install.rb#L27) to yum or apt to tell it what you'd like to do more specifically. In #571, someone else has figured out how to direct apt/dpkg to upgrade the way they want, but we didn't want to prescribe what end users want their package manager to do.

Alternately, you can add some logic to skip the install if the correct version is already installed (e.g. add `not_if "rpm -qa | grep -s elasticsearch"` to your `elasticsearch_install` resource).

### Elasticsearch is installed in the wrong directory name; the version is incorrect!

If you install by URL, and don't provide the version attribute to the `elasticsearch_install` resource, this cookbook can't tell what version you've provided (any arbitrary filename works, so there's no guarantee we can even figure it out). You will get the default version included in the directory name in this case, unless you specify which version you're installing as well. See #535 for more information.

### Elasticsearch won't start with configuration it doesn't recognize

There's a chicken-and-egg issue with installing a plugin and then configuring it. It would be nice if Elasticsearch allowed configuration settings that didn't do anything, and emitted a warning instead of a fatal error.

You have two options to workaround this -- (a) Don't start Elasticsearch until the plugin is installed; in other words, use one elasticsearch_configure and don't issue a :start action to elasticsearch_service until the plugin resource runs its own actions. Alternately, (b) check for whether or not x-pack is installed at the start of a Chef run, and don't configure any x-pack settings unless it's installed (this will require 2 chef runs to fully configure x-pack, as the ::File.exists? is evaluated very early in the Chef run), e.g.:
```
x_pack_installed = ::File.exists?("#{es_conf.path_plugins}/x-pack")

settings = {
   'http.port' => port,
   'cluster.name' => cluster_name,
   'node.name' => node_name,
   'bootstrap.memory_lock' => false,
   'discovery.zen.minimum_master_nodes' => 1
}

if x_pack_installed
   settings['xpack.monitoring.enabled'] = true
   ...
end

es_conf = elasticsearch_configure 'elasticsearch' do
    allocated_memory '512m'
    configuration settings
end
es_conf.path_data data_location if data_location

...
```

### .deb package installs fail inside containers

This is a known issue upstream and the packaging folks have been working to resolve it. You can follow along at:
https://github.com/elastic/elasticsearch/issues/25846
