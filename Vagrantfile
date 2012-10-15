# Launch and provision multiple Linux distributions with Vagrant <http://vagrantup.com>
#
# Support:
#
# * precise64: Ubuntu 12.04 (Precise) 64 bit (primary box)
# * lucid32:   Ubuntu 10.04 (Lucid) 32 bit
# * lucid64:   Ubuntu 10.04 (Lucid) 64 bit
# * centos6:   CentOS 6 32 bit
#
# See:
#
#   $ vagrant status
#
# The virtual machines are automatically provisioned upon startup with Chef-Solo
# <http://vagrantup.com/v1/docs/provisioners/chef_solo.html>.
#

begin
  require 'active_support/core_ext/hash/deep_merge'
rescue LoadError => e
  STDERR.puts '', "[!] ERROR -- Please install ActiveSupport (gem install activesupport)", '-'*80, ''
  raise e
end

# Automatically install and mount cookbooks from Berksfile
#
require 'berkshelf/vagrant'

distributions = {
  :precise64 => {
    :url      => 'http://files.vagrantup.com/precise64.box',
    :run_list => %w| apt vim java monit elasticsearch elasticsearch::plugins elasticsearch::proxy elasticsearch::aws elasticsearch::monit elasticsearch::test |,
    :ip       => '33.33.33.10',
    :primary  => true,
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
    :run_list => %w| yum::epel vim java elasticsearch elasticsearch::proxy elasticsearch::test |,
    :ip       => '33.33.33.12',
    :primary  => false,
    :node     => {
      :elasticsearch => {
        :nginx => {
          :user => 'nginx'
        }
      }
    }
  }
}

node_config = {
  :elasticsearch => {
    :cluster_name => "elasticsearch_vagrant",

    :plugins => {
      'karmi/elasticsearch-paramedic' => {}
    },

    :limits => {
      :nofile  => 1024,
      :memlock => 512
    },

    :nginx => {
      :user  =>  'www-data',
      :users => [{ username: 'USERNAME', password: 'PASSWORD' }]
    }
  }
}

Vagrant::Config.run do |config|

  distributions.each_pair do |name, options|

    config.vm.define name, :options => options[:primary] do |box_config|

      box_config.vm.box       = name.to_s
      box_config.vm.box_url   = options[:url]

      box_config.vm.host_name = name.to_s

      box_config.vm.network   :hostonly, options[:ip]

      box_config.vm.customize { |vm| vm.memory_size = 1024 }

      # Install latest Chef on the machine
      #
      config.vm.provision :shell do |shell|
        version = ENV['CHEF'].match(/^\d+/) ? ENV['CHEF'] : nil
        shell.inline = %Q{
          apt-get update --quiet --yes
          apt-get install curl --quiet --yes
          test -d "/opt/chef" || curl -# -L http://www.opscode.com/chef/install.sh | sudo bash -s -- #{version ? "-v #{version}" : ''}
        }
      end if ENV['CHEF']

      # Provision the machine with Chef Solo
      #
      box_config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path    = ['..', './tmp/cookbooks']
        chef.provisioning_path = '/etc/vagrant-chef'
        chef.log_level         = :debug

        chef.run_list = options[:run_list]
        chef.json     = node_config.deep_merge(options[:node])
      end
    end

  end

end
