#!/bin/bash
set -ex
top_dir="$(git rev-parse --show-toplevel)"

DESTDIR=${DESTDIR:=debian/ucaresystem}
rm -rf "$DESTDIR"

## Copy Main scripts
main_scripts=("remove-old-kernels" "ucaresystem" "ucaresystem-core")
mkdir -p "$DESTDIR/usr/bin"
for s in "${main_scripts[@]}"; do
  cp "${top_dir}/scripts/$s" "$DESTDIR/usr/bin/"

  # Fix library paths
  # shellcheck disable=SC2016
  new_lib_dir='"$(realpath "$(dirname "${BASH_SOURCE[0]}")/../lib/ucaresystem")"'
  sed -ri "s@^(lib_dir=)(.*)@\1${new_lib_dir}@g" "$DESTDIR/usr/bin/$s"
  # shellcheck disable=SC2016
  new_share_dir='"$(realpath "$(dirname "${BASH_SOURCE[0]}")/../share/ucaresystem")"'
  sed -ri "s@^(share_dir=)(.*)@\1${new_share_dir}@g" "$DESTDIR/usr/bin/$s"
done

## Copy Libraries
libraries=("config" "ucaresystem-cli" "ucaresystem-xterm" "task_cleanup" "task_check_eol" "task_maintain" "task_timeshift" "shflags")
mkdir -p "$DESTDIR/usr/lib/ucaresystem"
for s in "${libraries[@]}"; do
  cp "${top_dir}/scripts/$s" "$DESTDIR/usr/lib/ucaresystem"

  # Fix library paths
  # shellcheck disable=SC2016
  new_lib_dir='"$(realpath "$(dirname "${BASH_SOURCE[0]}")")"'
  sed -ri "s@^(lib_dir=)(.*)@\1${new_lib_dir}@g" "$DESTDIR/usr/lib/ucaresystem/$s"
  # shellcheck disable=SC2016
  new_share_dir='"$(realpath "$(dirname "${BASH_SOURCE[0]}")/../../share/ucaresystem")"'
  sed -ri "s@^(share_dir=)(.*)@\1${new_share_dir}@g" "$DESTDIR/usr/lib/ucaresystem/$s"
done

## Update VERSION NUMBER
VERSION=$(dpkg-parsechangelog -S Version)
new_version="\"${VERSION}\""
sed -ri "s/^(UCARE_VERSION=)(.*)/\1${new_version}/g" "$DESTDIR/usr/lib/ucaresystem/config"


## Policy files
mkdir -p "$DESTDIR/usr/share/polkit-1/actions"
cp assets/*.policy "$DESTDIR/usr/share/polkit-1/actions"

## Desktop file
mkdir -p "$DESTDIR/usr/share/applications"
cp assets/*.desktop "$DESTDIR/usr/share/applications"

## Icons
set +x
icon_sizes=("24" "28" "32" "36" "48" "96" "128" "256" "512")
for s in "${icon_sizes[@]}"; do
  dirname="usr/share/icons/hicolor/${s}x${s}/apps/"
  mkdir -p "${DESTDIR}/${dirname}"
  rsvg-convert -w "$s" -h "$s" assets/ucaresystem.svg --no-keep-image-data --output "${DESTDIR}/${dirname}/ucaresystem.png"
done

# Scalable icons
mkdir -p "${DESTDIR}/usr/share/icons/hicolor/scalable/apps"
cp assets/ucaresystem.svg "${DESTDIR}/usr/share/icons/hicolor/scalable/apps"
mkdir -p "${DESTDIR}/usr/share/icons/hicolor/symbolic/apps"
cp assets/ucaresystem-symbolic.svg "${DESTDIR}/usr/share/icons/hicolor/symbolic/apps"
set -x

## Misc Files
mkdir -p "$DESTDIR/usr/share/doc/ucaresystem"
cp assets/ucaresystem.conf.sample "$DESTDIR/usr/share/doc/ucaresystem"
cp README.md "$DESTDIR/usr/share/doc/ucaresystem"

## Manual pages
ronn --roff --manual="ucaresystem" --organization="Utappia" --date="2020-04-01" docs/ronn/*.ronn
mkdir -p "$DESTDIR/usr/share/man/man8"
mv docs/ronn/*.8 "$DESTDIR/usr/share/man/man8"

## Systemd-inhibit
mkdir -p "$DESTDIR/lib/systemd/system/"
mkdir -p "$DESTDIR/usr/share/ucaresystem/"
cp assets/ucaresystem-automation-cleanup.service "$DESTDIR/lib/systemd/system/"
cp assets/99-ucaresystem-temporary.pkla "$DESTDIR//usr/share/ucaresystem/"

## Misc Files at /usr/share/ucaresystem/
mkdir -p "$DESTDIR/usr/share/ucaresystem/"
share_files=("eterm-background.png" "xterm-launcher")
for s in "${share_files[@]}"; do
  cp "assets/$s" "$DESTDIR/usr/share/ucaresystem/"
done

## Banner
## https://boxes.thomasjensen.com/
grep -v '^#' assets/banner.txt.in| boxes -d dog -a c -s 80X12 > assets/banner.txt
cp assets/banner.txt "$DESTDIR/usr/share/ucaresystem/"

## Lines of code report
cloc . --vcs=git --quiet --report-file="$DESTDIR/usr/share/doc/ucaresystem/loc.txt"
sed -i '1d' "$DESTDIR/usr/share/doc/ucaresystem/loc.txt"
