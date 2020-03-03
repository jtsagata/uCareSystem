#!/usr/bin/env bash

set -ex

top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

# install dependencies
sudo apt-get install -y devscripts equivs
sudo mk-build-deps --install "${top_dir}/debian/control"
# Remove gen file
rm ucaresystem-build-deps*.*


# Make debian package
./support/make_debian.sh

# Find version number
VERSION=$(grep "Standards-Version" "${top_dir}/debian/control" | awk '{print $2}')

# Make tar release
pushd debian/ucaresystem/
tar cfz "${top_dir}/packages/ucaresystem-${VERSION}.tgz" usr
popd

