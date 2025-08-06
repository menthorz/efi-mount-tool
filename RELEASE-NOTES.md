# EFI Mount Tool v1.0.0 Release Notes

## 🇺🇸 English

### What's New in v1.0.0

**EFI Mount Tool** is now available with a complete dual-interface solution for managing EFI partitions on macOS!

### 🎉 Features

#### 🖥️ SwiftUI Native App
- **Modern Interface**: Beautiful native macOS design following Human Interface Guidelines
- **Easy Operation**: One-click mount/unmount operations
- **System Integration**: Automatic Finder opening after mounting
- **Help System**: Integrated help with step-by-step instructions
- **Error Handling**: Visual feedback for all operations

#### 🔧 Shell Script Interface
- **Colorful Terminal**: Interactive menu with colors and Unicode symbols
- **Auto Discovery**: Automatically finds all EFI partitions
- **Safe Operations**: Secure mounting with admin privilege checks
- **Detailed Feedback**: Comprehensive logging and status updates

### 📦 What's Included

- `EFI Swift GUI.app` - Native macOS application
- `efi_mount.sh` - Standalone shell script
- `build.sh` - Build script for developers
- Complete Swift source code
- MIT License

### 🚀 Installation

1. Download `EFI-Mount-Tool-v1.0.zip`
2. Extract the archive
3. Run `EFI Swift GUI.app` for GUI interface
4. Or use `sudo ./efi_mount.sh` for terminal interface

### ⚠️ System Requirements

- macOS 11.0+ (Big Sur or later)
- Administrator privileges
- Xcode 13.0+ (for building from source)

### 🔒 Security

- Uses only native macOS `diskutil` commands
- Requires admin privileges for mounting operations
- Safe mount/unmount with verification
- No external dependencies

---

## 🇧🇷 Português

### Novidades na v1.0.0

O **EFI Mount Tool** está agora disponível com uma solução completa de interface dupla para gerenciar partições EFI no macOS!

### 🎉 Funcionalidades

#### 🖥️ App Nativo SwiftUI
- **Interface Moderna**: Design nativo bonito do macOS seguindo as Diretrizes de Interface Humana
- **Operação Fácil**: Operações de montagem/desmontagem com um clique
- **Integração do Sistema**: Abertura automática no Finder após montagem
- **Sistema de Ajuda**: Ajuda integrada com instruções passo a passo
- **Tratamento de Erros**: Feedback visual para todas as operações

#### 🔧 Interface Shell Script
- **Terminal Colorido**: Menu interativo com cores e símbolos Unicode
- **Descoberta Automática**: Encontra automaticamente todas as partições EFI
- **Operações Seguras**: Montagem segura com verificações de privilégios de admin
- **Feedback Detalhado**: Logging abrangente e atualizações de status

### 📦 O que está incluído

- `EFI Swift GUI.app` - Aplicação nativa do macOS
- `efi_mount.sh` - Script shell autônomo
- `build.sh` - Script de compilação para desenvolvedores
- Código fonte Swift completo
- Licença MIT

### 🚀 Instalação

1. Baixe `EFI-Mount-Tool-v1.0.zip`
2. Extraia o arquivo
3. Execute `EFI Swift GUI.app` para interface gráfica
4. Ou use `sudo ./efi_mount.sh` para interface de terminal

### ⚠️ Requisitos do Sistema

- macOS 11.0+ (Big Sur ou posterior)
- Privilégios de administrador
- Xcode 13.0+ (para compilação do código fonte)

### 🔒 Segurança

- Usa apenas comandos nativos `diskutil` do macOS
- Requer privilégios de admin para operações de montagem
- Montagem/desmontagem segura com verificação
- Sem dependências externas

---

## 🎯 Use Cases / Casos de Uso

### For Hackintosh Users / Para Usuários Hackintosh
- Mount EFI partitions to configure OpenCore or Clover
- Edit config.plist files safely
- Install kexts and ACPI patches
- Backup and restore EFI configurations

### For macOS Power Users / Para Usuários Avançados do macOS
- Dual boot system management
- EFI partition maintenance and cleanup
- Boot configuration troubleshooting
- System recovery operations

### For Developers / Para Desenvolvedores
- Test boot configurations
- Develop and test bootloaders
- EFI partition analysis
- Automated EFI operations via scripting

## 🔄 Migration from Previous Versions

This is the first official release. If you were using development versions:
1. Remove any old installations
2. Download the new release package
3. Follow the installation instructions

## 🐛 Known Issues

- Requires admin privileges for all mounting operations (by design)
- Some external drives may need to be reconnected after unmounting
- Terminal interface requires manual password entry

## 🤝 Contributing

We welcome contributions! Please see the GitHub repository for:
- Bug reports
- Feature requests
- Code contributions
- Documentation improvements

## 📞 Support

Need help? Check our documentation or open an issue on GitHub:
- Detailed README with usage instructions
- Integrated help system in the GUI
- Community support via GitHub Issues

---

**Thank you for using EFI Mount Tool!**  
**Obrigado por usar o EFI Mount Tool!**

🔗 **Download**: [EFI-Mount-Tool-v1.0.zip](https://github.com/menthorz/efi-mount-tool/releases/download/v1.0.0/EFI-Mount-Tool-v1.0.zip)  
📖 **Documentation**: [README.md](https://github.com/menthorz/efi-mount-tool/blob/main/README.md)  
🐛 **Issues**: [GitHub Issues](https://github.com/menthorz/efi-mount-tool/issues)  
⭐ **Star the project**: [GitHub Repository](https://github.com/menthorz/efi-mount-tool)
