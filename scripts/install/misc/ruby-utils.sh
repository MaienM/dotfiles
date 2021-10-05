#!/usr/bin/env bash

set -o errexit -o pipefail

cd ~/.dotfiles

# shellcheck source=../_asdf_utils.sh
source scripts/install/_asdf_utils.sh

echo ">>> Checking dependencies."
asdf_guard
asdf_plugin_add ruby

echo ">>> Installing latest ruby."
asdf_install_latest_version ruby
echo "Using ruby $version."
ln -sTf "$HOME/.asdf/installs/ruby/$version" "$HOME/.asdf/installs/ruby/utils"

echo ">>> Installing utilities."
asdf reshim ruby
ASDF_RUBY_VERSION=utils asdf exec gem install asciidoctor
ASDF_RUBY_VERSION=utils asdf exec gem install facets pusher listen webrick commonmarker
asdf reshim ruby

