#!/bin/bash
do_sign=$1
SIGN_BY="tsagatakis@protonmail.com"

top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

# install dependencies
#sudo apt-get update
#sudo apt-get install -y devscripts equivs
#sudo mk-build-deps --install "${top_dir}/debian/control"

#
# Make Debian package
#
if [[ -n $do_sign ]]; then
  dpkg-buildpackage -F -k${SIGN_BY}
else
  dpkg-buildpackage -F
fi

#
# Check for errors with lintian
#
lintian --verbose -I ${ARTIFACTS}/*.changes

#
# Find version number
#
VERSION=$(grep "Standards-Version" "${top_dir}/debian/control" | awk '{print $2}')


#
# move source artifacts
#
ARTIFACTS="dist"
mkdir -p ${ARTIFACTS}
rm -f ${ARTIFACTS}/*
mv ../ucare*.deb ${ARTIFACTS}
mv "../ucaresystem_${VESRION}"*.* ${ARTIFACTS}
ls ${ARTIFACTS}

#echo "Enter root password to install package"
#sudo dpkg -i dist/ucaresystem_4.5.0_all.deb

