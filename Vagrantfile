Vagrant::Config.run do |config|

  config.vm.define :lucid32 do |dist_config|
    dist_config.vm.box       = 'lucid32'
    dist_config.vm.box_url   = 'http://files.vagrantup.com/lucid32.box'

    dist_config.vm.customize do |vm|
      vm.name        = 'elasticsearch'
      vm.memory_size = 1024
    end

    dist_config.vm.network :bridged, '33.33.33.10'

    dist_config.vm.provision :chef_solo do |chef|

      chef.cookbooks_path    = [ '/tmp/elasticsearch-cookbooks' ]
      chef.provisioning_path = '/etc/vagrant-chef'
      chef.log_level         = :debug

      chef.run_list = %w| minitest-handler
      		        apt
                        java
                        vim
                        monit
                        elasticsearch |

      chef.json = {
        elasticsearch: {
          cluster_name: "elasticsearch_vagrant",

          limits: {
            nofile:  1024,
            memlock: 512
            }
		
          }
	}
    end
  end


  config.vm.define :lucid64 do |dist_config|
    dist_config.vm.box       = 'lucid64'
    dist_config.vm.box_url   = 'http://files.vagrantup.com/lucid64.box'

    dist_config.vm.customize do |vm|
      vm.name        = 'elasticsearch'
      vm.memory_size = 1024
    end

    dist_config.vm.network :bridged, '33.33.33.10'

    dist_config.vm.provision :chef_solo do |chef|

      chef.cookbooks_path    = [ File.expand_path('../', __FILE__),
                                 File.expand_path('../tmp/cookbooks', __FILE__)
                               ]
      chef.provisioning_path = '/etc/vagrant-chef'
      chef.log_level         = :debug

      chef.run_list = %w| apt
                        java
                        vim
                        nginx
                        monit
                        elasticsearch
                        elasticsearch::proxy_nginx
                        elasticsearch::plugin_aws
                        elasticsearch::test |

      chef.json = {
        elasticsearch: {
          cluster_name: "elasticsearch_vagrant",

          limits: {
            nofile:  1024,
            memlock: 512
          },

          nginx: {
            users: [{
                      username: 'USERNAME',
                      password: 'PASSWORD'
                    }]
          }
        }
      }

    end
  end

  config.vm.define :centos6_32 do |dist_config|
    dist_config.vm.box       = 'centos6_32'
    dist_config.vm.box_url   = 'http://vagrant.sensuapp.org/centos-6-i386.box'

    dist_config.vm.customize do |vm|
      vm.name        = 'elasticsearch'
      vm.memory_size = 1024
    end

    dist_config.vm.network :bridged, '33.33.33.10'

    dist_config.vm.provision :chef_solo do |chef|

      chef.cookbooks_path    = [ '/tmp/elasticsearch-cookbooks' ]
      chef.provisioning_path = '/etc/vagrant-chef'
      chef.log_level         = :debug

      chef.run_list = %w| minitest-handler
                        java
			yum::epel
                        vim
                        elasticsearch |

      chef.json = {
        elasticsearch: {
          cluster_name: "elasticsearch_vagrant",

          limits: {
            nofile:  1024,
            memlock: 512
            }
		
          }
	}
    end
  end

end
