#!/bin/bash

VERSION=$1

# == EDIT PATHS IN THESE VARIABLES ====
MAIN_PUBSPEC="org.purplegraphite.code/pubspec.yaml"
CONST_STRING_DART="./org.purplegraphite.code/lib/src/commons/strings.dart"
# == END ==============================

LAST_VERSION="$(sed -n -e 's/^.*version: //p' ${MAIN_PUBSPEC})"

echo "The previous version was: $LAST_VERSION"

if [ -z "$VERSION" ]; then
    echo
    echo "No version specified."
    echo "Usage: tools/update_version.sh NEW_VERSION_NUMBER"
    exit 1
fi

printf "\nThis will change project's version from $LAST_VERSION to $VERSION\n"
read -p "Are you sure you want to continue? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]
then
    exit 0
fi

printf "\nUpdating pubspec versions.."

# perl -pi -e "s/^(\\W*version:) $LAST_VERSION/\$1 $VERSION/g" $PUBSPECS
python tools/support/snr.py "version: ${LAST_VERSION}" "version: $VERSION" $MAIN_PUBSPEC
# perl -pi -e "s/^(\\W*version:) [0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS

printf "\nUpdating versions in app source code where required.."
# Update version defined in the source code in app.
# perl -pi -e "s/^(\\W*static const String applicationVersion =) '[0-9.beta-]+'/\$1 '$VERSION'/g" $CONST_STRING_DART
python tools/support/snr.py "static const String applicationVersion = '${LAST_VERSION}'" "static const String applicationVersion = '$VERSION'" $CONST_STRING_DART

NEW_VERSION="$(sed -n -e 's/^.*version: //p' ${MAIN_PUBSPEC})"

printf "\n\nUpdated version to: $NEW_VERSION\n"

# == NOT REQUIRED IN THIS PROJECT ====
# # Update the version of all packages/applications.

# # If you add a package that is version locked, please add it to this list as
# # "./org.floraprobe/pubspec.yaml \
# # ./packages/<other_package/other_pubspecs>"
# PUBSPECS="./${MAIN_PUBSPEC}"

# pushd packages

# # We could use LAST_VERSION instead of allowing any previous version

# # Update all references to package versions
# perl -pi -e "s/^(\\W*package1:) \\^?[0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS
# perl -pi -e "s/^(\\W*package2:) \\^?[0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS
# perl -pi -e "s/^(\\W*package3:) \\^?[0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS
# perl -pi -e "s/^(\\W*package4:) \\^?[0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS
# perl -pi -e "s/^(\\W*package5:) \\^?[0-9.beta-]+/\$1 $VERSION/g" $PUBSPECS

# popd
# == END ====