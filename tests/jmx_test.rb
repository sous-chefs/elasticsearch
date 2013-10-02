describe_recipe 'elasticsearch::jmx' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "Installation" do

    it "update configuration files" do
      file("/usr/local/etc/elasticsearch/elasticsearch-env.sh").
        must_exist.
        must_include("4092")
    end

  end

end
