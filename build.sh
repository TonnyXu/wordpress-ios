#!/bin/sh

#Parameters
PROJECT_NAME="WordPress"
SOURCE_ROOT="$PWD/$PROJECT_NAME"
SDK="iphoneos"
CONFIGURATION="Debug"
WORKSPACE_NAME="WordPress.xcworkspace"
SCHEME_NAME="WordPress"
PRODUCT_NAME="WordPress"
OUT_APP_DIR="appFile"
OUT_IPA_DIR="ipaFile"
DATE=`date +%Y%m%d`
VERSION="V3.4.0"
IPA_FILE_NAME="WordPress-$CONFIGURATION-$VERSION-$DATE"
DEVELOPPER_NAME="iPhone Distribution: genesix, Inc."
PROVISIONING_PATH="${HOME}/Library/MobileDevice/Provisioning\ Profiles/345E1F49-53BE-4AC6-9B9D-764E78406C6F.mobileprovision"



if [ ! -d ${OUT_IPA_DIR} ]; then
  mkdir "${OUT_IPA_DIR}"
fi

#echo $SOURCE_ROOT
echo "Cleaning $PROJECT_NAME now..."
xcodebuild clean -workspace "${WORKSPACE_NAME}" -scheme "${SCHEME_NAME}" > /dev/null
echo "Building $PROJECT_NAME now..."
xcodebuild -workspace "${WORKSPACE_NAME}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -scheme "${SCHEME_NAME}" install DSTROOT="${OUT_APP_DIR}" #> /dev/null
echo "Archiving $PROJECT_NAME now..."
xcrun -sdk "${SDK}" PackageApplication "${PWD}/${OUT_APP_DIR}/Applications/${PRODUCT_NAME}.app" -o "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" -embed "${PROVISIONING_PATH}" #> /dev/null

#scp "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" genesixdev@genesixdev.local:~/Sites/GGTV
#[ -f ./afterBuild.personal.sh ] && source "afterBuild.personal.sh" "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa"

#rm -rf ${OUT_APP_DIR}
#rm -rf ${OUT_IPA_DIR}
#rm -rf ${PWD}/build

