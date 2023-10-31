control 'Elasticsearch package' do
  describe package('elasticsearch') do
    it { should be_installed }
  end
end

include_controls 'default'
