#!/usr/bin/env bash
set -e
echo "Getting repository info"
top_dir="$(git rev-parse --show-toplevel)"

cd "$top_dir"

push_url=$(git remote show origin  | grep "Push  URL"  | cut -d ' ' -f6)
fetch_url=$(git remote show origin | grep "Fetch URL"  | cut -d ' ' -f5)
echo "push_url: '$push_url'"
echo "fetch_url: '$fetch_url'"

yes| rm -r /tmp/pages_ucaresystem
mkdir /tmp/pages_ucaresystem
git clone ${fetch_url} /tmp/pages_ucaresystem

pushd /tmp/pages_ucaresystem/
git checkout gh-pages
cp -r "$top_dir/docs/html/"* .

find . -name "*" | grep -v "git"
git add *
git commit -m "rebuild manual $(date +%F_%T)"
git push "${push_url}" gh-pages
popd