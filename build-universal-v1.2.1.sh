#!/bin/bash

# EFI Mount Tool v1.2.1 Universal Binary Build Script
# Professional release without emojis and with English interface

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Version and app info
VERSION="1.2.1"
APP_NAME="EFI Mount Tool"
BUNDLE_ID="com.menthorz.efi-mount-tool"
BUILD_DIR="build"
DIST_DIR="dist"
SOURCE_DIR="EFI-Swift-GUI"

echo -e "${CYAN}===========================================${NC}"
echo -e "${CYAN}   EFI Mount Tool v${VERSION} Universal Build${NC}"
echo -e "${CYAN}   Professional Release${NC}"
echo -e "${CYAN}===========================================${NC}"

# Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
rm -rf "${BUILD_DIR}"
rm -rf "${DIST_DIR}"
mkdir -p "${BUILD_DIR}"
mkdir -p "${DIST_DIR}"

# Convert iconset to icns if needed
if [ -d "NewAppIcon.iconset" ] && [ ! -f "AppIcon.icns" ]; then
    echo -e "${CYAN}Converting iconset to icns...${NC}"
    iconutil -c icns NewAppIcon.iconset -o AppIcon.icns
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Icon converted successfully!${NC}"
    fi
fi

cd "${SOURCE_DIR}"

# Check if Package.swift exists
if [ ! -f "Package.swift" ]; then
    echo -e "${RED}Package.swift not found!${NC}"
    exit 1
fi

echo -e "${BLUE}Building for ARM64 (Apple Silicon)...${NC}"
swift build -c release --arch arm64
if [ $? -eq 0 ]; then
    echo -e "${GREEN}ARM64 build successful!${NC}"
    cp .build/arm64-apple-macosx/release/EFI-Swift-GUI "../${BUILD_DIR}/EFI-Swift-GUI-arm64"
else
    echo -e "${YELLOW}ARM64 build failed, skipping...${NC}"
fi

echo -e "${BLUE}Building for x86_64 (Intel)...${NC}"
swift build -c release --arch x86_64
if [ $? -eq 0 ]; then
    echo -e "${GREEN}x86_64 build successful!${NC}"
    cp .build/x86_64-apple-macosx/release/EFI-Swift-GUI "../${BUILD_DIR}/EFI-Swift-GUI-x86_64"
else
    echo -e "${YELLOW}x86_64 build failed, skipping...${NC}"
fi

cd ..

# Create universal binary if both architectures exist
if [ -f "${BUILD_DIR}/EFI-Swift-GUI-arm64" ] && [ -f "${BUILD_DIR}/EFI-Swift-GUI-x86_64" ]; then
    echo -e "${CYAN}Creating universal binary...${NC}"
    lipo -create \
        "${BUILD_DIR}/EFI-Swift-GUI-arm64" \
        "${BUILD_DIR}/EFI-Swift-GUI-x86_64" \
        -output "${BUILD_DIR}/EFI-Swift-GUI-universal"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Universal binary created successfully!${NC}"
        
        # Verify the binary
        echo -e "${CYAN}Verifying universal binary...${NC}"
        file "${BUILD_DIR}/EFI-Swift-GUI-universal"
        lipo -info "${BUILD_DIR}/EFI-Swift-GUI-universal"
        
        # Copy to dist with version
        cp "${BUILD_DIR}/EFI-Swift-GUI-universal" "${DIST_DIR}/EFI-Mount-Tool-Universal-v${VERSION}"
        chmod +x "${DIST_DIR}/EFI-Mount-Tool-Universal-v${VERSION}"
        
        # Apply custom icon if available
        if [ -f "AppIcon.icns" ]; then
            echo -e "${CYAN}Applying custom app icon...${NC}"
            # Create a temporary app bundle structure for icon application
            TEMP_APP="${BUILD_DIR}/EFI Mount Tool.app"
            mkdir -p "${TEMP_APP}/Contents/MacOS"
            mkdir -p "${TEMP_APP}/Contents/Resources"
            
            # Copy the binary
            cp "${BUILD_DIR}/EFI-Swift-GUI-universal" "${TEMP_APP}/Contents/MacOS/EFI Mount Tool"
            chmod +x "${TEMP_APP}/Contents/MacOS/EFI Mount Tool"
            
            # Copy the icon
            cp "AppIcon.icns" "${TEMP_APP}/Contents/Resources/AppIcon.icns"
            
            # Create Info.plist
            cat > "${TEMP_APP}/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>EFI Mount Tool</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>${BUNDLE_ID}</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleDisplayName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleVersion</key>
    <string>${VERSION}</string>
    <key>CFBundleShortVersionString</key>
    <string>${VERSION}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF
            
            # Copy app bundle to dist
            cp -R "${TEMP_APP}" "${DIST_DIR}/"
            echo -e "${GREEN}App bundle with custom icon created!${NC}"
        fi
        
        echo -e "${GREEN}Build complete!${NC}"
        echo -e "${CYAN}Universal binary saved as: ${DIST_DIR}/EFI-Mount-Tool-Universal-v${VERSION}${NC}"
        
    else
        echo -e "${RED}Failed to create universal binary!${NC}"
        exit 1
    fi
elif [ -f "${BUILD_DIR}/EFI-Swift-GUI-arm64" ]; then
    echo -e "${YELLOW}Only ARM64 build available, using single architecture...${NC}"
    cp "${BUILD_DIR}/EFI-Swift-GUI-arm64" "${DIST_DIR}/EFI-Mount-Tool-ARM64-v${VERSION}"
    chmod +x "${DIST_DIR}/EFI-Mount-Tool-ARM64-v${VERSION}"
elif [ -f "${BUILD_DIR}/EFI-Swift-GUI-x86_64" ]; then
    echo -e "${YELLOW}Only x86_64 build available, using single architecture...${NC}"
    cp "${BUILD_DIR}/EFI-Swift-GUI-x86_64" "${DIST_DIR}/EFI-Mount-Tool-x86_64-v${VERSION}"
    chmod +x "${DIST_DIR}/EFI-Mount-Tool-x86_64-v${VERSION}"
else
    echo -e "${RED}No successful builds found!${NC}"
    exit 1
fi

# Create release package
echo -e "${CYAN}Creating release package...${NC}"
cd "${DIST_DIR}"

# Create zip package
if [ -d "EFI Mount Tool.app" ]; then
    zip -r -9 "EFI-Mount-Tool-App-Bundle-v${VERSION}.zip" "EFI Mount Tool.app"
fi
zip -9 "EFI-Mount-Tool-Universal-v${VERSION}.zip" EFI-Mount-Tool-Universal-v${VERSION} 2>/dev/null || \
zip -9 "EFI-Mount-Tool-ARM64-v${VERSION}.zip" EFI-Mount-Tool-ARM64-v${VERSION} 2>/dev/null || \
zip -9 "EFI-Mount-Tool-x86_64-v${VERSION}.zip" EFI-Mount-Tool-x86_64-v${VERSION} 2>/dev/null

cd ..

echo -e "${GREEN}===========================================${NC}"
echo -e "${GREEN}   Build completed successfully!${NC}"
echo -e "${GREEN}   Version: ${VERSION}${NC}"
echo -e "${GREEN}   Files created in: ${DIST_DIR}/${NC}"
echo -e "${GREEN}===========================================${NC}"

# List created files
echo -e "${CYAN}Created files:${NC}"
ls -la "${DIST_DIR}/"
