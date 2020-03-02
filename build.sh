#!/bin/bash
set -ex
base_name="$(basename "$0")"
dir_name="$(dirname "$0")"
VERSION="5.0.0"

DESTDIR=${DESTDIR:=debian/ucaresystem}
yes| rm -rf "$DESTDIR"

## Copy Main scripts
main_scripts=("launch-ucaresystem" "remove-old-kernels" "ucaresystem" "ucaresystem-core" )
mkdir -p "$DESTDIR/usr/bin"
for s in "${main_scripts[@]}"; do
  cp "${dir_name}/scripts/$s" "$DESTDIR/usr/bin/"
  new_version="\"${VERSION}\""
  sed -ri "s/^(UCARE_VERSION=)(.*)/\1${new_version}/g" "$DESTDIR/usr/bin/$s"
  new_lib_dir='"../lib/ucaresystem"'
  sed -ri "s@^(lib_dir=)(.*)@\1${new_lib_dir}@g" "$DESTDIR/usr/bin/$s"
done

## Copy Libraries
libraries=("base")
mkdir -p "$DESTDIR/usr/lib/ucaresystem"
for s in "${libraries[@]}"; do
  cp "${dir_name}/scripts/$s" "$DESTDIR/usr/lib/ucaresystem"
done

## Policy files
mkdir -p "$DESTDIR/usr/share/polkit-1/actions"
cp assets/*.policy "$DESTDIR/usr/share/polkit-1/actions"

## Desktop file
mkdir -p "$DESTDIR/usr/share/applications"
cp assets/*.desktop "$DESTDIR/usr/share/applications"

## Icons
mkdir -p "$DESTDIR/usr/share/icons"
cp assets/*.png "$DESTDIR/usr/share/icons"

## Misc Files
mkdir -p "$DESTDIR/usr/share/doc/ucaresystem"
cp assets/ucaresystem.conf.sample "$DESTDIR/usr/share/doc/ucaresystem"
