#!/bin/bash
do_sign=$1

VERSION="4.5.0"

SIGN_BY="tsagatakis@protonmail.com"


ARTIFACTS="dist"

top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

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

# move source artifacts
mkdir -p ${ARTIFACTS}
rm -f ${ARTIFACTS}/*
mv ../ucare*.deb ${ARTIFACTS}
mv "../ucaresystem_${VESRION}"*.* ${ARTIFACTS}
ls ${ARTIFACTS}



#echo "Enter root password to install package"
#sudo dpkg -i dist/ucaresystem_4.5.0_all.deb

popd
