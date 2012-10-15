Chef::Log.debug "Installing and configuring minitest and minitest-chef-handler"

chef_gem "minitest"
chef_gem "minitest-chef-handler"

require "minitest-chef-handler"

test_pattern = './**/*elasticsearch*/files/default/tests/**/*_test.rb'
Chef::Log.debug "Will run these tests: #{Dir[test_pattern].entries.inspect}"

handler = MiniTest::Chef::Handler.new({
  :path    => test_pattern,
  :verbose => true
})

Chef::Log.info("Enabling minitest-chef-handler as a report handler")
Chef::Config.send("report_handlers") << handler
