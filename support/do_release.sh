#!/usr/bin/env bash
#
#    do_release.h - helper script to upload to github releases
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

set -exu
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

#
# Find version number (Fix for normal release)
#
DEB_VERSION=$(dpkg-parsechangelog -S Version)
OLD_RELEASE_TAG="v.${DEB_VERSION}-beta"
NEW_RELEASE_TAG="v.${DEB_VERSION}-beta"


# Get it from here https://github.com/github/hub
HUB=/usr/local/bin/hub

echo "Getting repository info"
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

set +e
release_info=$(${HUB} release show "$OLD_RELEASE_TAG")
set -e

# Make and sign the distribution packages
./support/make_debian.sh --sign


if [[ -z $release_info  ]]; then
  echo "$OLD_RELEASE_TAG have been already deleted."
else
  echo "Delete Release $OLD_RELEASE_TAG"
  ${HUB} release delete "$OLD_RELEASE_TAG"
  git push --delete origin "$OLD_RELEASE_TAG"
fi

message1="${NEW_RELEASE_TAG}"
message2="This is beta software. Use at your own risk."
message3="The file you need is ucaresystem_${DEB_VERSION}_all.deb."
message4="If you have install the package from PPA download and install both debs."

${HUB} release create --prerelease \
      --attach dist/ucaresystem_${DEB_VERSION}_all.deb \
      --attach dist/ucaresystem-core_${DEB_VERSION}_all.deb \
      --attach dist/ucaresystem_${DEB_VERSION}.tar.bz2 \
      --attach dist/ucaresystem_${DEB_VERSION}.dsc \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.buildinfo \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.changes \
      --message "$message1" \
      --message "$message2" \
      --message "$message3" \
      --message "$message4" \
      --browse \
      "${NEW_RELEASE_TAG}"

set +e
${HUB} release show "$NEW_RELEASE_TAG"
set -e

# TODO: Download and check sigs of tar and debs