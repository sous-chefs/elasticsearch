[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Loads configuration settings from data bag 'elasticsearch/data' or from node attributes.
#
# In a data bag, you can define multiple devices to be formatted and/or mounted:
#
#    {
#      "elasticsearch": {
#        "data" : {
#          "devices" : {
#            "/dev/sdb" : {
#              "file_system"      : "ext3",
#              "mount_options"    : "rw,user",
#              "mount_path"       : "/usr/local/var/data/elasticsearch/disk1",
#              "format_command"   : "mkfs.ext3",
#              "fs_check_command" : "dumpe2fs",
#            }
#          }
#        }
#      }
#    }
#
# To set the configuration with nodes attributes (eg. for Chef Solo), see the Vagrantfile.
# See <http://wiki.opscode.com/display/chef/Setting+Attributes+(Examples)> for more info.
#
# You have to add the `mount_path` of each defined device to `default.elasticsearch[:path][:data]`,
# either as a comma-delimited string or as a Ruby/JSON array, so it is used in the Elasticsearch
# configuration.
#
# For EC2, you can define additional parameters for creating and attaching EBS volumes:
#
#    {
#      "elasticsearch": {
#        "data" : {
#          "devices" : {
#            "/dev/sda2" : {
#              "file_system"      : "ext3",
#              "mount_options"    : "rw,user",
#              "mount_path"       : "/usr/local/var/data/elasticsearch/disk1",
#              "format_command"   : "mkfs.ext3",
#              "fs_check_command" : "dumpe2fs",
#              "ebs"            : {
#                "region"                : "us-east-1", // Optional: instance region is used by default
#                "size"                  : 250,         // In GB
#                "delete_on_termination" : true,
#                "type"                  : "io1",
#                "iops"                  : 2000
#              }
#            }
#          }
#        }
#      }
#    }
#
#
# When you define a `snapshot_id` property for an EBS device, it will be created from that snapshot,
# having all the data available in the snapshot:
#
#    {
#      "elasticsearch": {
#        "data" : {
#          "devices" : {
#            "/dev/sda2" : {
#              # ...
#              "ebs" : {
#                # ...
#                "snapshot_id" : "snap-123abc4d"
#              }
#            }
#          }
#        }
#      }
#    }
#
data = Chef::DataBagItem.load('elasticsearch', 'data')[node.chef_environment] rescue {}

default.elasticsearch[:data][:devices] = data['devices'] || {}
