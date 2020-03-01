#!/bin/bash

set -ex
DESTDIR=${DESTDIR:=debian/ucaresystem-core}

## Scripts
mkdir -p "$DESTDIR/usr/bin"
cp scripts/* "$DESTDIR/usr/bin/"

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
mkdir -p "$DESTDIR/usr/share/doc/ucaresystem-core"
cp assets/ucaresystem.conf "$DESTDIR/usr/share/doc/ucaresystem-core"







