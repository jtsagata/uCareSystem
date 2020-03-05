#!/bin/bash
ARTIFACTS="dist"

dir_name="$(dirname "$0")"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

pushd "${dir_name}/.."

dpkg-buildpackage -b

# move source artifacts
mkdir -p ${ARTIFACTS}
rm -f ${ARTIFACTS}/* 

mv ../ucare*.deb ${ARTIFACTS}
mv ../ucare*.buildinfo ${ARTIFACTS} 
mv ../ucare*.changes ${ARTIFACTS} 

#echo "*********TRANSIENT*******"
#find debian/ucaresystem-core -name "*"
#echo "*********BASIC*******"
#find debian/ucaresystem -name "*"
#echo "****************"

lintian ${ARTIFACTS}/*.changes

echo "Enter root password to install package"
sudo dpkg -i dist/ucaresystem_4.5.0_all.deb

popd
