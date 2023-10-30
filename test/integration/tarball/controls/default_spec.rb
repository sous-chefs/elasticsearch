control 'Tarball Install' do
  title 'Verify installation'
  describe file("#{dir}/elasticsearch-#{version}"), if: tarball? do
    it { should be_directory }
    it { should be_owned_by 'elasticsearch' }
    it { should be_grouped_into 'elasticsearch' }
  end

  describe file("#{dir}/elasticsearch"), if: tarball? do
    it { should be_symlink }
  end

  describe file('/usr/local/bin/elasticsearch'), if: tarball? do
    it { should be_symlink }
    it { should be_linked_to("#{dir}/elasticsearch-#{version}/bin/elasticsearch") }
  end
end
