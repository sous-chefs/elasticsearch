describe_recipe 'elasticsearch::jmx' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "Installation" do


    it 'update configuration file' do
      
    
      file("#{node.elasticsearch[:path][:conf]}/elasticsearch-env.sh").
          must_exist.
          must_include("-Dcom.sun.management.jmxremote.port=#{node.elasticsearch[:jmx_config][:port]}")
    end
      
      
    #it 'service is started with correct option' do
    #  assert system('ps -elf | grep java | grep "-Dcom.sun.management.jmxremote.port"')
    # end
 end

end
