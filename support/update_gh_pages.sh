#!/usr/bin/env bash
set -ex
echo "Getting repository info"
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

push_url=$(git remote show origin  | grep "Push  URL"  | cut -d ' ' -f6)
fetch_url=$(git remote show origin | grep "Fetch URL"  | cut -d ' ' -f5)
echo "push_url: '$push_url'"
echo "fetch_url: '$fetch_url'"

set +e
yes| rm -r /tmp/pages_ucaresystem
set -e

mkdir /tmp/pages_ucaresystem
git clone ${fetch_url} /tmp/pages_ucaresystem

pushd /tmp/pages_ucaresystem/
git checkout gh-pages

# Empty all files
git rm -r *

# Copy files
cp -r "$top_dir/docs/html/"* .

# Create manual pages
mkdir -p "/tmp/pages_ucaresystem/man"
ronn --html --warnings --style toc --manual="ucaresystem" --organization="Utappia" --date="2020-04-01" "$top_dir/docs/ronn/"*.ronn
#mv $top_dir/docs/ronn/*.1.html "/tmp/pages_ucaresystem/man/"
mv $top_dir/docs/ronn/*.8.html "/tmp/pages_ucaresystem/man/"

# Show list of files
find . -name "*" | grep -v "git"

git add *
mod_date=$((date +"%F %T")
git commit -m "rebuild manual at ${mod_date}"
git push "${push_url}" gh-pages



popd