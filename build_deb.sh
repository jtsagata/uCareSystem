#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARTIFACTS="packages"

pushd "${DIR}"

dpkg-buildpackage -b

# move source artifacts
mkdir -p ${ARTIFACTS}
rm -f ${ARTIFACTS}/* 

mv ../ucare*.deb ${ARTIFACTS}
mv ../ucare*.buildinfo ${ARTIFACTS} 
mv ../ucare*.changes ${ARTIFACTS} 

echo "*********TRANSIENT*******"
find debian/ucaresystem-core -name "*"
echo "*********BASIC*******"
find debian/ucaresystem -name "*"
echo "****************"


lintian ${ARTIFACTS}/*.changes



#sudo apt remove -y ucaresystem-core
#sudo dpkg -i packages/*.deb

popd
