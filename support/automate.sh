#!/usr/bin/env bash
set -ex

top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

# PGP
declare -r custom_gpg_home="${top_dir}/.ci"
declare -r secring_auto="${custom_gpg_home}/secring.auto"
declare -r pubring_auto="${custom_gpg_home}/pubring.auto"

echo
echo "Decrypting secret gpg keyring.."
# $super_secret_password is taken from the script's env.
# https://blogs.itemis.com/en/secure-your-travis-ci-releases-part-2-signature-with-openpgp
echo $PGP_SECRET | gpg --passphrase-fd 0 "${secring_auto}".gpg
if [ $retval -ne 0 ]; then
    echo "Failed to decrypt secret gpg keyring."
    exit 1
fi
echo Success!

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

