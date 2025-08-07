# 🎉 EFI Mount Tool v1.2.0 - Professional Release

**Release Date**: August 7, 2025  
**Tag**: `v1.2.0`  
**Universal Binary**: ✅ Intel (x86_64) + Apple Silicon (ARM64)

---

## 🎯 Major Highlights

### Professional Interface Transformation
- **🚫 Emoji-Free Design**: Removed all emojis for a clean, professional appearance
- **🌍 English Localization**: Converted all Portuguese text to English for international usability
- **💼 Enterprise Ready**: Interface suitable for professional and corporate environments
- **✨ Enhanced Clarity**: Improved text consistency and readability throughout the application

### Universal Architecture Support
- **🔧 Intel (x86_64)**: Full native support for Intel-based Macs
- **⚡ Apple Silicon (ARM64)**: Optimized for Apple Silicon performance
- **🔄 Universal Binary**: Single download works on all supported Mac architectures
- **📱 Custom App Icon**: Professional custom icon integrated in macOS app bundle

---

## 📦 Release Assets

| Asset | Description | Size | Architecture |
|-------|-------------|------|--------------|
| **EFI-Mount-Tool-App-Bundle-v1.2.0.zip** | Complete macOS app bundle with custom icon | 2.6 MB | Universal |
| **EFI-Mount-Tool-Universal-v1.2.0.zip** | Standalone universal binary | 400 KB | Universal |

---

## ✨ Features Carried Forward

### From v1.1.3 - Password-Free Unmounting
- Multi-stage unmounting system (unmount → force → eject)
- No administrator password required for unmounting operations
- Enhanced reliability with smart fallback mechanisms

### From v1.1.2 - Scroll Support
- ScrollView with LazyVStack for handling multiple EFI partitions
- Maximum height of 300px with smooth scrolling
- Improved UI organization for better partition management

### Core Functionality
- **EFI Partition Discovery**: Automatic detection of EFI partitions on internal and external drives
- **Safe Operations**: Secure mounting/unmounting with proper error handling
- **Finder Integration**: Direct access to mounted EFI partitions
- **System Information**: Comprehensive system details and disk information
- **Native macOS**: Built with SwiftUI for optimal macOS experience

---

## 🔧 Technical Improvements

### Code Quality
- **Clean Architecture**: Improved code organization and documentation
- **English Comments**: All code comments converted to English
- **Professional Messaging**: Updated error messages and user notifications
- **Consistent Terminology**: Standardized interface text throughout the application

### Build System Enhancement
- **Automated Icon Conversion**: iconset to icns conversion in build script
- **App Bundle Creation**: Proper macOS app bundle structure with Info.plist
- **Universal Binary Verification**: Automated architecture verification with `lipo`
- **Professional Packaging**: Enhanced release packaging with multiple formats

---

## 🎨 Interface Changes

### Before (v1.1.3)
```
🔍 Descobrir Partições
💾 /dev/disk0s1
📁 Abrir no Finder
⚙️ Configurações
```

### After (v1.2.0)
```
Discover Partitions
/dev/disk0s1
Open in Finder
Settings
```

---

## 🏗️ Build Information

- **Framework**: SwiftUI
- **Minimum macOS**: 12.0
- **Architectures**: x86_64 (Intel) + ARM64 (Apple Silicon)
- **Bundle ID**: `com.menthorz.efi-mount-tool`
- **Icon**: Custom high-resolution AppIcon.icns (2.2 MB)

---

## 🚀 Installation & Usage

### App Bundle (Recommended)
1. Download `EFI-Mount-Tool-App-Bundle-v1.2.0.zip`
2. Extract and move `EFI Mount Tool.app` to Applications
3. Launch from Applications or Spotlight

### Standalone Binary
1. Download `EFI-Mount-Tool-Universal-v1.2.0.zip`
2. Extract and place binary in desired location
3. Run from Terminal or Finder

### First Launch
- Grant administrator privileges when prompted for mounting operations
- The app will automatically discover available EFI partitions
- Use the clean, professional interface to manage EFI partitions

---

## 🌟 Professional Use Cases

- **🏢 Enterprise Environments**: Clean interface suitable for corporate IT departments
- **🛠️ System Administration**: Professional tool for EFI partition management
- **🌐 International Teams**: English interface for global accessibility
- **🎯 Technical Support**: Reliable interface for troubleshooting and maintenance

---

## 📊 Version Comparison

| Version | Key Features | Interface | Architecture |
|---------|--------------|-----------|--------------|
| v1.1.2 | Scroll functionality | Portuguese + Emojis | Single |
| v1.1.3 | Password-free unmounting | Portuguese + Emojis | Single |
| **v1.2.0** | **Professional interface** | **English, No Emojis** | **Universal** |

---

## 🔗 Links

- **Repository**: [efi-mount-tool](https://github.com/menthorz/efi-mount-tool)
- **Issues**: [Report bugs or request features](https://github.com/menthorz/efi-mount-tool/issues)
- **Releases**: [All releases](https://github.com/menthorz/efi-mount-tool/releases)

---

## 📝 Release Notes

This release represents a significant milestone in the evolution of EFI Mount Tool, transforming it from a functional utility to a professional-grade application suitable for enterprise use. The removal of emojis and conversion to English makes it internationally accessible while maintaining all the powerful features that made previous versions successful.

The universal binary ensures optimal performance on all supported Mac architectures, while the custom app icon and proper macOS app bundle provide a polished, professional experience that integrates seamlessly with the macOS ecosystem.

**Perfect for**: IT professionals, system administrators, developers, and anyone needing reliable EFI partition management with a clean, professional interface.

---

*Built with ❤️ for the macOS community*
