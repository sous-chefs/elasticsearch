describe_recipe 'elasticsearch::data' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it "mounts the secondary disk" do
     mount("#{node.elasticsearch[:path][:data]}", :device => "/dev/sdb").
       must_be_mounted \
       if node.recipes.include?("elasticsearch::data")
  end

  it "correctly creates the data directory" do
    directory("#{node.elasticsearch[:path][:data]}").
      must_exist.
      with(:owner, 'elasticsearch') \
      if node.recipes.include?("elasticsearch::data")
  end

end
