#!/bin/bash
set -e

APP_NAME="NCISM Assessment Tool"
BUILD_DIR="dist-native"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
DMG_NAME="NCISM Assessment Tool-1.0.0-arm64.dmg"
OUTPUT_DMG="dist/$DMG_NAME"

echo "==> Cleaning previous build directories..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "dist"

echo "==> Compiling native desktop executable..."
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

swiftc -O -target arm64-apple-macos11.0 \
  native/main.swift \
  -o "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

echo "==> Bundling UI resources..."
cp index.html "$APP_BUNDLE/Contents/Resources/"
cp styles.css "$APP_BUNDLE/Contents/Resources/"
cp renderer.js "$APP_BUNDLE/Contents/Resources/"

cat << 'EOF' > "$APP_BUNDLE/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>NCISM Assessment Tool</string>
    <key>CFBundleIdentifier</key>
    <string>com.ncism.textbookassessment</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>NCISM Assessment Tool</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026 Ministry of AYUSH / NCISM. All rights reserved.</string>
</dict>
</plist>
EOF

# Add link to Applications folder inside DMG staging folder for standard Mac installer feel
mkdir -p "$BUILD_DIR/dmg-staging"
cp -R "$APP_BUNDLE" "$BUILD_DIR/dmg-staging/"
ln -s /Applications "$BUILD_DIR/dmg-staging/Applications"

echo "==> Creating optimized standalone .dmg installer..."
rm -f "$OUTPUT_DMG"
hdiutil create -volname "$APP_NAME" -srcfolder "$BUILD_DIR/dmg-staging" -ov -format UDZO "$OUTPUT_DMG"

echo "==> Build complete!"
ls -lh "$OUTPUT_DMG"
