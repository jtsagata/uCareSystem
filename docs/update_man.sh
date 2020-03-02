#!/bin/bash

# sudo gem install ronn

# Build man pages
ronn -w -s toc -r5 --markdown ronn/*.ronn

# Move man pages to proper locations
mv ronn/*.1 man/      >/dev/null 2>&1
mv ronn/*.8 man/      >/dev/null 2>&1
mv ronn/*.html html/  >/dev/null 2>&1

mv ronn/*.markdown md/
for f in md/*.markdown; do
    mv -- "$f" md/"$(basename -- "$f" .markdown).md"
done
