#!/usr/bin/env bash
set -ex

OLD_RELEASE_TAG="v.4.5.0-beta"
NEW_RELEASE_TAG="v.4.5.0-beta"
DEB_VERSION="4.5.0"

# Get it from here https://github.com/github/hub
HUB=/usr/local/bin/hub

# TODO build deb and tar
# TODO sign debs and tars

echo "Getting repository info"
top_dir="$(git rev-parse --show-toplevel)"
pushd "$top_dir"

set +e
release_info=$(${HUB} release show "$OLD_RELEASE_TAG")
set -e

#./support/make_debian.sh


exit

if [[ -z $release_info  ]]; then
  echo "$OLD_RELEASE_TAG have been already deleted."
else
  echo "Delete Release $OLD_RELEASE_TAG"
  ${HUB} release delete "$OLD_RELEASE_TAG"
  git push --delete origin "$OLD_RELEASE_TAG"
fi

message="${NEW_RELEASE_TAG}. Use at your own risk"

${HUB} release create --prerelease \
      --attach dist/ucaresystem-core_${DEB_VERSION}_all.deb \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.buildinfo \
      --attach dist/ucaresystem_${DEB_VERSION}_amd64.changes \
      --message "$message" \
      --browse \
      "${NEW_RELEASE_TAG}"

set +e
${HUB} release show "$NEW_RELEASE_TAG"
set -e

# TODO: Download and check sigs of tar and debs
popd