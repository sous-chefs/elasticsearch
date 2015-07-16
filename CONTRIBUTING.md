Contributing to cookbook-elasticsearch
======================================

### Workflow for contributing

1. Create a branch directly in this repo or a fork (if you don't have push access). Please name branches within this repository `<github username>/<description>`. For example, something like karmi/install_from_deb.

1. Create an issue or open a PR. If you aren't sure your PR will solve the issue, or may be controversial, we commend opening an issue separately and linking to it in your PR, so that if the PR is not accepted, the issue will remain and be tracked.

1.  Close (and reference) issues by the `closes #XXX` or `fixes #XXX` notation in the commit message. Please use a descriptive, useful commit message that could be used to understand why a particular change was made.

1. Keep pushing commits to the initial branch, `--amend`-ing if necessary. Please don't mix fixing unrelated issues in a single branch.

1. When everything is ready for merge, clean up the branch (rebase with master to synchronize, squash, edit commits, etc) to prepare for it to be merged.

### Merging contributions

1. After reviewing commits for documentation, passing CI tests, and good descriptive commit messages, merge it with --no-ff switch, so it's indicated in the Git history

1. Do not use the Github "merge button", since it doesn't do a fast-forward merge (see previous item).


### Releasing

1. Create/update the changelog. We are using the `github_changelog_generator`
gem.

1. We highly recommend using the `stove` project, which pushes cookbooks to
Supermarket and tags to Github.
