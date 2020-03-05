#!/usr/bin/env bash
set -exu
top_dir="$(git rev-parse --show-toplevel)"
cd "$top_dir"

#
# Find version number (Fix for normal release)
#
DEB_VERSION=$(grep "Standards-Version" "${top_dir}/debian/control" | awk '{print $2}')
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

${HUB} release create --prerelease \
      --attach dist/ucaresystem_${DEB_VERSION}_all.deb \
      --attach dist/ucaresystem-core_${DEB_VERSION}_all.deb \
      --attach dist/ucaresystem_${DEB_VERSION}.tar.bz2 \
      --attach dist/ucaresystem_${DEB_VERSION}.dsc \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.buildinfo \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.changes \
      --message "$message1" \
      --message "$message2" \
      --browse \
      "${NEW_RELEASE_TAG}"

set +e
${HUB} release show "$NEW_RELEASE_TAG"
set -e

# TODO: Download and check sigs of tar and debs