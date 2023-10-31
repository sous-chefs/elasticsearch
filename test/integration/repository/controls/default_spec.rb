describe package('elasticsearch') do
  it { should be_installed }
end

include_controls 'default'
