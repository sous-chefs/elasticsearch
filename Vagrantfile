# Launch and provision multiple Linux distributions with Vagrant <http://vagrantup.com>
#
# Support:
#
# * lucid32: Ubuntu Lucid 32 bit
# * lucid64: Ubuntu Lucid 64 bit (primary box)
# * centos6: CentOS 6 32 bit
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

distributions = {
  :lucid64 => {
    :url      => 'http://files.vagrantup.com/lucid64.box',
    :run_list => %w| minitest-handler apt java vim nginx monit elasticsearch elasticsearch::proxy_nginx |,
    :ip       => '33.33.33.10',
    :primary  => true,
    :node     => {}
  },

  :lucid32 => {
    :url      => 'http://files.vagrantup.com/lucid32.box',
    :run_list => %w| minitest-handler apt java vim nginx monit elasticsearch elasticsearch::proxy_nginx |,
    :ip       => '33.33.33.11',
    :primary  => false,
    :node     => {}
  },

  :centos6 => {
    :url      => 'http://vagrant.sensuapp.org/centos-6-i386.box',
    :run_list => %w| minitest-handler java yum::epel vim nginx elasticsearch elasticsearch::proxy_nginx |,
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
