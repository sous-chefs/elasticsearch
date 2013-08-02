describe_recipe 'elasticsearch::default' do

  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "Installation" do

    it "installs libraries to versioned directory" do
      version = node[:elasticsearch][:version]

      directory("#{node.elasticsearch[:dir]}/elasticsearch-#{node[:elasticsearch][:version]}").
        must_exist.
        with(:owner, 'elasticsearch')
    end

    it "installs elasticsearch jar" do
      version = node[:elasticsearch][:version]

      file("#{node.elasticsearch[:dir]}/elasticsearch-#{version}/lib/elasticsearch-#{version}.jar").
        must_exist.
        with(:owner, 'elasticsearch')
    end if Chef::VERSION > '10.14'

    it "has a link to versioned directory" do
      version = node[:elasticsearch][:version]

      link("#{node.elasticsearch[:dir]}/elasticsearch").
        must_exist.
        with(:link_type, :symbolic).
        and(:to, "#{node.elasticsearch[:dir]}/elasticsearch-#{version}")
    end

    it "creates configuration files" do
      file("#{node.elasticsearch[:path][:conf]}/elasticsearch.yml").
        must_exist

      file("#{node.elasticsearch[:path][:conf]}/elasticsearch-env.sh").
        must_exist.
        must_include("ES_HOME='#{node.elasticsearch[:dir]}/elasticsearch'")
    end

    it "creates the configuration file with proper content" do
      file("#{node.elasticsearch[:path][:conf]}/elasticsearch.yml").
        must_include("cluster.name: elasticsearch_vagrant").
        must_include("path.data: /var/data/elasticsearch/disk1").
        must_include("bootstrap.mlockall: false").
        must_include("index.search.slowlog.threshold.query.trace: 1ms").
        must_include("discovery.zen.ping.timeout: 9s").
        must_include("threadpool.index.size: 2")

      if node.name == 'precise64'
        file("#{node.elasticsearch[:path][:conf]}/elasticsearch.yml").
          must_include("node.name: precise64")
      end
    end

    it "creates logging file" do
      file("#{node.elasticsearch[:path][:conf]}/logging.yml").
        must_exist.
        must_include("logger.action: DEBUG").
        must_include("logger.discovery: TRACE")
    end

  end

end
