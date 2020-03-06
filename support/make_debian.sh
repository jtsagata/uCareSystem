#!/bin/bash
#
#    make_debian.sh - helper script to create the debian packages
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

param=$1
SIGN_BY="tsagatakis@protonmail.com"

ARTIFACTS="dist"
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir" || exit

VERSION=$(grep "Standards-Version" "${top_dir}/debian/control" | awk '{print $2}')

# hack for travis
if [[ $param == "--travis" ]]; then
  # install dependencies
  sudo apt-get update
  sudo apt-get install -y devscripts equivs lintian
  sudo mk-build-deps --install "${top_dir}/debian/control"
else
  mk-build-deps "${top_dir}/debian/control"
fi

#
# Make Debian package
#
if [[ $param == "--sign" ]]; then
  dpkg-buildpackage -F -k${SIGN_BY}
else
  dpkg-buildpackage -F
fi

# Parse changelog to get latest version
VERSION=$(dpkg-parsechangelog -S Version)

#
# move source artifacts
#
mkdir -p ${ARTIFACTS}
rm -f ${ARTIFACTS}/*
mv ../ucare*.deb ${ARTIFACTS}
mv "../ucaresystem_${VERSION}"*.* ${ARTIFACTS}
mv "ucaresystem-build-deps_${VERSION}_all.deb" ${ARTIFACTS}

#
# Check for errors with lintian
#
echo "*** Debian linting errors"
lintian --display-experimental --display-info "${ARTIFACTS}/"*.changes



#echo "Enter root password to install package"
#sudo dpkg -i dist/ucaresystem_4.5.0_all.deb

