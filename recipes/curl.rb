include_recipe "elasticsearch::_default"

package 'curl' do
  action :install
end
