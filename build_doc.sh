set -e

PACKAGE_TARGET="PKSNavigation"


xcodebuild docbuild -scheme "${PACKAGE_TARGET}" \
  -derivedDataPath /tmp/docbuild \
  -destination 'generic/platform=iOS';

$(xcrun --find docc) process-archive \
 transform-for-static-hosting /tmp/docbuild/Build/Products/Debug-iphoneos/${PACKAGE_TARGET}.doccarchive \
  --hosting-base-path ${PACKAGE_TARGET} \
  --output-path docs;
