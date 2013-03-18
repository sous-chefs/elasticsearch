desc "Create a release tag and push everything to Github"
task :release do
  unless system("git status --porcelain").to_s =~ /^\s*$/
    puts "[!] Error, repository dirty, please commit or stash your changes.", ""
    exit(1)
  end
  if version = File.read('metadata.rb')[/^version\s*"(.*)"$/, 1]
    sh <<-COMMAND.gsub(/      /, ' ')
      git tag #{version} && \
      git push origin master --verbose && \
      git push origin --tags --verbose && \
      knife cookbook site share "elasticsearch" "Databases"
    COMMAND
  end
end
