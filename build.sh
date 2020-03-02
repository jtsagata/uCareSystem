#!/bin/bash

set -ex
DESTDIR=${DESTDIR:=debian/ucaresystem}

## Scripts
mkdir -p "$DESTDIR/usr/bin"
cp scripts/* "$DESTDIR/usr/bin/"
ln -sf "$DESTDIR/usr/bin/ucacesystem" "$DESTDIR/usr/bin/ucacesystem-core"

## Policy files
mkdir -p "$DESTDIR/usr/share/polkit-1/actions"
cp assets/*.policy  $DESTDIR/usr/share/polkit-1/actions


## Desktop file
mkdir -p "$DESTDIR/usr/share/applications"
cp assets/*.desktop "$DESTDIR/usr/share/applications"

## Icons
mkdir -p "$DESTDIR/usr/share/icons"
cp assets/*.png "$DESTDIR/usr/share/icons"

## Manual pages
(cd man && make)

## Misc Files
mkdir -p "$DESTDIR/usr/share/doc/ucaresystem"
cp assets/ucaresystem.conf.sample "$DESTDIR/usr/share/doc/ucaresystem"







