#!/usr/bin/env bash
#
#    update_gh_pages.sh - helper script to create the project website
#    Copyright:
#       2020 Ioannis Tsagatakis <tsagatakis@protonmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -ex
echo "Getting repository info"
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

push_url=$(git remote show origin  | grep "Push  URL"  | cut -d ' ' -f6)
fetch_url=$(git remote show origin | grep "Fetch URL"  | cut -d ' ' -f5)
echo "push_url: '$push_url'"
echo "fetch_url: '$fetch_url'"

set +e
rm -rf /tmp/pages_ucaresystem
set -e

mkdir /tmp/pages_ucaresystem
git clone "${fetch_url}" /tmp/pages_ucaresystem

pushd /tmp/pages_ucaresystem/
git checkout gh-pages

# Empty all files
git rm -r ./*

# Copy files
cp -r "$top_dir/docs/html/"* .

# Create manual pages
mkdir -p "/tmp/pages_ucaresystem/man"
ronn --html --warnings --style toc --manual="ucaresystem" --organization="Utappia" --date="2020-04-01" "$top_dir/docs/ronn/"*.ronn
mv "$top_dir"/docs/ronn/*.8.html "/tmp/pages_ucaresystem/man/"

# Show list of files
find . -name "*" | grep -v "git"

git add ./*
mod_date=$(date +"%F %T")
git commit -m "rebuild manual at ${mod_date}"
git push "${push_url}" gh-pages

popd #/tmp/pages_ucaresystem/

xdg-open https://jtsagata.github.io/uCareSystem/