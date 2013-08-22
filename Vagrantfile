# Launch and provision multiple Linux distributions with Vagrant <http://vagrantup.com>
#
# Support:
#
# * precise64:   Ubuntu 12.04 (Precise) 64 bit (primary box)
# * lucid32:     Ubuntu 10.04 (Lucid) 32 bit
# * lucid64:     Ubuntu 10.04 (Lucid) 64 bit
# * centos6:     CentOS 6 32 bit
#
# See:
#
#   $ vagrant status
#
# The virtual machines are automatically provisioned upon startup with Chef-Solo
# <http://vagrantup.com/v1/docs/provisioners/chef_solo.html>.
#

# Lifted from <https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/deep_merge.rb>
#
class Hash
  def deep_merge!(other_hash)
    self.merge(other_hash) do |key, oldval, newval|
      oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
      newval = newval.to_hash if newval.respond_to?(:to_hash)
      oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? oldval.dup.deep_merge!(newval) : newval
    end
  end unless respond_to?(:deep_merge!)
end

puts "[Vagrant   ] #{Vagrant::VERSION}"

# Automatically install and mount cookbooks from Berksfile
#
require 'berkshelf/vagrant' if Vagrant::VERSION < '1.1'

distributions = {
  :precise64 => {
    :url      => 'http://files.vagrantup.com/precise64.box',
    :run_list => %w| apt build-essential vim java monit elasticsearch elasticsearch::plugins elasticsearch::proxy elasticsearch::aws elasticsearch::data elasticsearch::monit elasticsearch::test |,
    :ip       => '33.33.33.10',
    :primary  => true,
    :node     => {
      :elasticsearch => {
        :path => {
          :data => %w| /usr/local/var/data/elasticsearch/disk1 /usr/local/var/data/elasticsearch/disk2 |
        },
        :data => {
          :devices   => {
            "/dev/sdb" => {
              :file_system      => "ext3",
              :mount_options    => "rw,user",
              :mount_path       => "/usr/local/var/data/elasticsearch/disk1",
              :format_command   => "mkfs.ext3 -F",
              :fs_check_command => "dumpe2fs"
            },
            "/dev/sdc" => {
              :file_system      => "ext3",
              :mount_options    => "rw,user",
              :mount_path       => "/usr/local/var/data/elasticsearch/disk2",
              :format_command   => "mkfs.ext3 -F",
              :fs_check_command => "dumpe2fs"
            }
          }
        }
      }
    }
  },

  :precise32 => {
    :url      => 'http://files.vagrantup.com/precise32.box',
    :run_list => %w| apt vim java monit elasticsearch elasticsearch::proxy elasticsearch::monit |,
    :ip       => '33.33.33.10',
    :primary  => false,
    :node     => {}
  },

  :lucid64 => {
    :url      => 'http://files.vagrantup.com/lucid64.box',
    :run_list => %w| apt vim java monit elasticsearch elasticsearch::proxy elasticsearch::monit |,
    :ip       => '33.33.33.10',
    :primary  => false,
    :node     => {}
  },

  :lucid32 => {
    :url      => 'http://files.vagrantup.com/lucid32.box',
    :run_list => %w| apt vim java monit elasticsearch elasticsearch::proxy elasticsearch::monit |,
    :ip       => '33.33.33.11',
    :primary  => false,
    :node     => {}
  },

  :centos6 => {
    # Note: Monit cookbook broken on CentOS
    :url      => 'https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-centos-6.3.box',
    :run_list => %w| yum::epel build-essential vim java elasticsearch elasticsearch::proxy elasticsearch::data elasticsearch::test |,
    :ip       => '33.33.33.12',
    :primary  => false,
    :node     => {
      :java => {
        :install_flavor => "openjdk",
        :jdk_version => "7"
      },
      :elasticsearch => {
        :path => {
          :data => "/usr/local/var/data/elasticsearch/disk1"
        },
        :data => {
          :devices   => {
            "/dev/sdb" => {
              :file_system      => "ext3",
              :mount_options    => "rw,user",
              :mount_path       => "/usr/local/var/data/elasticsearch/disk1",
              :format_command   => "mkfs.ext3 -F",
              :fs_check_command => "dumpe2fs"
            }
          }
        },

        :nginx => {
          :user => 'nginx'
        }
      }
    }
  }
}

node_config = {
  :elasticsearch => {
    :cluster => { :name => "elasticsearch_vagrant" },

    :plugins => {
      'karmi/elasticsearch-paramedic' => {
        :url => 'https://github.com/karmi/elasticsearch-paramedic/archive/master.zip'
      }
    },

    :limits => {
      :nofile  => 1024,
      :memlock => 512
    },
    :bootstrap => {
      :mlockall => false
    },

    :logging => {
      :discovery => 'TRACE',
      'index.indexing.slowlog' => 'INFO, index_indexing_slow_log_file'
    },

    :nginx => {
      :user  =>  'www-data',
      :users => [{ username: 'USERNAME', password: 'PASSWORD' }]
    },
    # For testing flat attributes:
    "index.search.slowlog.threshold.query.trace" => "1ms",
    # For testing deep attributes:
    :discovery => { :zen => { :ping => { :timeout => "9s" } } },
    # For testing custom configuration
    :custom_config => {
      'threadpool.index.type' => 'fixed',
      'threadpool.index.size' => '2'
    }
  }
}

Vagrant::Config.run do |config|

  distributions.each_pair do |name, options|

    config.vagrant.dotfile_name = Vagrant::VERSION < '1.1' ? '.vagrant-1' : '.vagrant-2'

    config.vm.define name, :options => options[:primary] do |box_config|

      box_config.vm.box       = name.to_s
      box_config.vm.box_url   = options[:url]

      box_config.vm.host_name = name.to_s

      box_config.vm.network   :hostonly, options[:ip]

      box_config.berkshelf.enabled = true if Vagrant::VERSION > '1.1'

      # Box customizations
      #
      # 1. Limit memory to 512 MB
      #
      box_config.vm.customize ["modifyvm", :id, "--memory", 512]
      #
      # 2. Create additional disks
      #
      if name == :precise64 or name == :centos6
        disk1, disk2 = "tmp/disk-#{Time.now.to_f}.vdi", "tmp/disk-#{Time.now.to_f}.vdi"
        box_config.vm.customize ["createhd", "--filename", disk1, "--size", 250]
        box_config.vm.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1,"--type", "hdd", "--medium", disk1]
        box_config.vm.customize ["createhd", "--filename", disk2, "--size", 250]
        box_config.vm.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2,"--type", "hdd", "--medium", disk2]
      end

      # Update packages on the machine
      #
      config.vm.provision :shell do |shell|
        shell.inline = %Q{
          which apt-get > /dev/null 2>&1 && apt-get update --quiet --yes && apt-get install curl --quiet --yes
          which yum > /dev/null 2>&1 && yum update -y && yum install curl -y
        }
      end if ENV['UPDATE']

      # Install latest Chef on the machine
      #
      config.vm.provision :shell do |shell|
        version = ENV['CHEF'].match(/^\d+/) ? ENV['CHEF'] : nil
        shell.inline = %Q{
          which apt-get > /dev/null 2>&1 && apt-get install curl --quiet --yes
          which yum > /dev/null 2>&1 && yum install curl -y
          test -d "/opt/chef" || curl -# -L http://www.opscode.com/chef/install.sh | sudo bash -s -- #{version ? "-v #{version}" : ''}
          /opt/chef/embedded/bin/gem list pry | grep pry || /opt/chef/embedded/bin/gem install pry --no-ri --no-rdoc
        }
      end if ENV['CHEF']

      # Provision the machine with Chef Solo
      #
      box_config.vm.provision :chef_solo do |chef|
        chef.data_bags_path    = './tmp/data_bags'
        chef.provisioning_path = '/etc/vagrant-chef'
        chef.log_level         = :debug

        chef.run_list = options[:run_list]
        chef.json     = node_config.dup.deep_merge!(options[:node])
      end
    end

  end

end
