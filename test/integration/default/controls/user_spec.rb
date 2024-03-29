control 'User' do
  describe group('elasticsearch') do
    it { should exist }
  end

  describe user('elasticsearch') do
    it { should exist }
    it { should have_login_shell '/bin/bash' }
    it { should belong_to_group 'elasticsearch' }
  end
end
