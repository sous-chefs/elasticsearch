require_relative 'spec_helper'

describe 'standard elasticsearch install and configure' do
  it_behaves_like 'elasticsearch user'
  it_behaves_like 'elasticsearch install'
  it_behaves_like 'elasticsearch configure'
  it_behaves_like 'elasticsearch plugin', 'x-pack'
  it_behaves_like 'elasticsearch service'
end
