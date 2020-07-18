#!/bin/bash
MAIN_PUBSPEC="org.purplegraphite.code/pubspec.yaml"
CURRENT_VERSION="$(sed -n -e 's/^.*version: //p' ${MAIN_PUBSPEC})"

echo "Tagging version: $CURRENT_VERSION"

printf "\nAre you sure you have updated project's version,\nCHANGELOG.md, README.md, Documentation?\n"
read -p "Continue? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
    exit 0
fi

set -x #echo on

git tag -a v$CURRENT_VERSION -m "Code $CURRENT_VERSION"

git push origin v$CURRENT_VERSION