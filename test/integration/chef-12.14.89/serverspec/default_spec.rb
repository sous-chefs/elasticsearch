require_relative 'spec_helper'

describe 'standard elasticsearch install and configure' do
  it_behaves_like 'elasticsearch user'
  it_behaves_like 'elasticsearch install'
  it_behaves_like 'elasticsearch configure'
  it_behaves_like 'elasticsearch plugin', 'x-pack'
  it_behaves_like 'elasticsearch service'

  it_behaves_like 'chef version', '12.14.89'
end
