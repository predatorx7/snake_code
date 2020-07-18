#!/bin/bash
MAIN_FLUTTER_APP="org.purplegraphite.code"


MAIN_PUBSPEC="$MAIN_FLUTTER_APP/pubspec.yaml"
CURRENT_VERSION="$(sed -n -e 's/^.*version: //p' ${MAIN_PUBSPEC})"

echo "Current version: v$CURRENT_VERSION"
echo "Latest release: $(git describe --abbrev=0)"
echo
printf "Current contributors: \n"
contributors=$(git shortlog -sne --all)
echo "$contributors"
echo
echo "Flutter project size: $(du -sh ./$MAIN_FLUTTER_APP)"
git gc --quiet
git_object_count=$(git count-objects -vH)
SIZE_PACK=$(sed -n -e 's/^.*size-pack: //p' <<< "$git_object_count")
echo "Repository size: $SIZE_PACK (exact disk space consumed)"