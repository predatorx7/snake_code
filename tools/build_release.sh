export KEY_ALIAS=$1
export STORE_PASSWORD=$2
echo "Building release.."
if [ -z "$1" ] || [ -z "$2" ]; then
    echo
    echo "KEY_ALIAS or STORE_PASSWORD has not been specified."
    echo "Usage: tools/build_release.sh KEY_ALIAS STORE_PASSWORD"
    exit 1
fi
if [ -e org.purplegraphite.code/release.jks ]
then
    echo
else
    echo
    echo "Release keystore file \"org.purplegraphite.code/release.jks\" doesn't exist."
    exit 1
fi
flutter build apk --release --split-per-abi --split-debug-info=output/symbols;