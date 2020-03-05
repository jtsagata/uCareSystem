#!/usr/bin/env bash
#
# This will build the packages, sign them and upload to github Releases
#
set -ex

top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

# install dependencies
sudo apt-get update
sudo apt-get install -y devscripts equivs
sudo mk-build-deps --install "${top_dir}/debian/control"

# Make debian package
./support/make_debian.sh

# Find version number
VERSION=$(grep "Standards-Version" "${top_dir}/debian/control" | awk '{print $2}')

# Make tar release
pushd debian/ucaresystem/
tar cfz "${top_dir}/dist/ucaresystem-${VERSION}.tgz" usr
popd

