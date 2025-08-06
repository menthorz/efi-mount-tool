# EFI Mount Tool

> 🔧 A complete tool for managing EFI partitions on macOS with native graphical interface  
> 🔧 Uma ferramenta completa para gerenciar partições EFI no macOS com interface gráfica nativa

![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg?style=for-the-badge)

[🇺🇸 English](#english) | [🇧🇷 Português](#português)

---

## 🇺🇸 English

### 📖 About

**EFI Mount Tool** is a complete solution for discovering, mounting, and managing EFI partitions on macOS. It offers both a colorful command-line interface and a native SwiftUI graphical interface.

### ✨ Features

- 🔍 **Auto Discovery**: Detects all available EFI partitions
- 🖥️ **Dual Interface**: Colorful terminal + native macOS GUI
- 🔒 **Security**: Safe mount/unmount operations
- 📁 **Integration**: Automatic Finder opening after mounting
- ⚡ **Performance**: Fast and efficient execution
- 🎨 **Design**: Follows macOS Human Interface Guidelines

### 🚀 Installation

#### Prerequisites

- macOS 11.0+ (Big Sur or later)
- Xcode 13.0+ (for compilation)
- Administrator privileges

#### Quick Start

1. Download the latest release ZIP
2. Extract and run `EFI Swift GUI.app`
3. Or use terminal: `sudo ./efi_mount.sh`

#### Building from Source

```bash
git clone https://github.com/menthorz/efi-mount-tool.git
cd efi-mount-tool/EFI-Swift-GUI
./build.sh
```

### 🖥️ Usage

#### Graphical Interface

1. Run `EFI Swift GUI.app`
2. Click **"Discover Partitions"** to find EFIs
3. Select a partition from the list
4. Use **"Mount EFI"** to access files
5. Edit necessary files
6. Use **"Unmount EFI"** when finished

#### Terminal Interface

```bash
sudo ./efi_mount.sh
```

### 📋 Features Overview

#### SwiftUI GUI
- ✅ EFI partition list with details
- ✅ One-click mount/unmount
- ✅ System information display
- ✅ Integrated help system
- ✅ Native macOS interface
- ✅ Visual error handling

#### Terminal Interface
- ✅ Interactive colorful menu
- ✅ Automatic EFI discovery
- ✅ Safe mounting with feedback
- ✅ Finder integration
- ✅ Detailed logging

### ⚠️ Security Warnings

> **⚠️ IMPORTANT**: This app requires administrator privileges

- 🛡️ **Always backup** before modifying EFI files
- 🔐 **Use carefully** - changes can affect system boot
- 🧪 **Test changes** in a safe environment first
- 📝 **Document changes** for easy rollback

### 🎯 Use Cases

- **Hackintosh**: Bootloader configuration (OpenCore, Clover)
- **Dual Boot**: Multi-system management
- **Maintenance**: EFI partition cleanup and organization
- **Development**: Boot configuration testing
- **Recovery**: Boot issue troubleshooting

### 🏗️ Project Structure

```
EFI-Mount-Tool/
├── README.md                    # This file
├── LICENSE                      # MIT License
├── efi_mount.sh                 # Main script (backend)
├── EFI-Mount-Tool-v1.0.zip     # Release package
└── EFI-Swift-GUI/              # Graphical interface
    ├── Package.swift            # Swift Package config
    ├── build.sh                 # Build script
    ├── Sources/                 # Swift source code
    └── EFI Swift GUI.app/      # Compiled app
```

### 🛠️ Development

#### Technologies
- **Backend**: Shell Script (Bash) with diskutil commands
- **Frontend**: SwiftUI with native macOS patterns
- **Build**: Swift Package Manager
- **Design**: Human Interface Guidelines

#### Contributing
1. Fork the project
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 🇧🇷 Português

### 📖 Sobre

O **EFI Mount Tool** é uma solução completa para descobrir, montar e gerenciar partições EFI no macOS. Oferece tanto uma interface de linha de comando colorida quanto uma interface gráfica nativa em SwiftUI.

### ✨ Características

- 🔍 **Descoberta Automática**: Detecta todas as partições EFI disponíveis
- 🖥️ **Interface Dupla**: Terminal colorido + GUI nativa do macOS
- 🔒 **Segurança**: Operações seguras de montagem/desmontagem
- 📁 **Integração**: Abertura automática no Finder após montagem
- ⚡ **Performance**: Execução rápida e eficiente
- 🎨 **Design**: Segue as diretrizes de interface do macOS

### 🚀 Instalação

#### Pré-requisitos

- macOS 11.0+ (Big Sur ou superior)
- Xcode 13.0+ (para compilação)
- Privilégios de administrador

#### Início Rápido

1. Baixe o ZIP da versão mais recente
2. Extraia e execute `EFI Swift GUI.app`
3. Ou use o terminal: `sudo ./efi_mount.sh`

#### Compilação do Código Fonte

```bash
git clone https://github.com/menthorz/efi-mount-tool.git
cd efi-mount-tool/EFI-Swift-GUI
./build.sh
```

### 🖥️ Uso

#### Interface Gráfica

1. Execute `EFI Swift GUI.app`
2. Clique em **"Descobrir Partições"** para buscar EFIs
3. Selecione uma partição na lista
4. Use **"Montar EFI"** para acessar os arquivos
5. Edite os arquivos necessários
6. Use **"Desmontar EFI"** quando terminar

#### Interface de Terminal

```bash
sudo ./efi_mount.sh
```

### 📋 Funcionalidades

#### Interface SwiftUI
- ✅ Lista de partições EFI com detalhes
- ✅ Montagem/desmontagem com um clique
- ✅ Informações do sistema
- ✅ Ajuda integrada
- ✅ Interface nativa do macOS
- ✅ Tratamento de erros visual

#### Interface de Terminal
- ✅ Menu interativo colorido
- ✅ Descoberta automática de EFIs
- ✅ Montagem segura com feedback
- ✅ Integração com Finder
- ✅ Logs detalhados

### ⚠️ Avisos de Segurança

> **⚠️ IMPORTANTE**: Este app requer privilégios de administrador

- 🛡️ **Sempre faça backup** antes de modificar arquivos EFI
- 🔐 **Use com cuidado** - alterações podem afetar o boot do sistema
- 🧪 **Teste mudanças** em ambiente seguro primeiro
- 📝 **Documente alterações** para facilitar reversão

### 🎯 Casos de Uso

- **Hackintosh**: Configuração de bootloaders (OpenCore, Clover)
- **Dual Boot**: Gerenciamento de múltiplos sistemas
- **Manutenção**: Limpeza e organização da partição EFI
- **Desenvolvimento**: Testes de configurações de boot
- **Recuperação**: Correção de problemas de inicialização

### 🏗️ Estrutura do Projeto

```
EFI-Mount-Tool/
├── README.md                    # Este arquivo
├── LICENSE                      # Licença MIT
├── efi_mount.sh                 # Script principal (backend)
├── EFI-Mount-Tool-v1.0.zip     # Pacote de release
└── EFI-Swift-GUI/              # Interface gráfica
    ├── Package.swift            # Configuração Swift Package
    ├── build.sh                 # Script de compilação
    ├── Sources/                 # Código fonte Swift
    └── EFI Swift GUI.app/      # App compilado
```

### 🛠️ Desenvolvimento

#### Tecnologias
- **Backend**: Shell Script (Bash) com comandos diskutil
- **Frontend**: SwiftUI com padrões nativos do macOS
- **Build**: Swift Package Manager
- **Design**: Human Interface Guidelines da Apple

#### Contribuindo
1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

---

## 🔧 Commands Used / Comandos Utilizados

The app uses native macOS commands / O app usa comandos nativos do macOS:

- `diskutil list` - List all disks and partitions / Lista todos os discos e partições
- `diskutil mount <identifier>` - Mount a partition / Monta uma partição
- `diskutil unmount <identifier>` - Unmount a partition / Desmonta uma partição
- `diskutil info <identifier>` - Get detailed information / Obtém informações detalhadas

## 📄 License / Licença

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🤝 Support / Suporte

If you encounter problems or have suggestions / Se encontrar problemas ou tiver sugestões:

1. Open an [issue](https://github.com/menthorz/efi-mount-tool/issues) / Abra uma [issue](https://github.com/menthorz/efi-mount-tool/issues)
2. Describe the problem in detail / Descreva o problema detalhadamente
3. Include logs and screenshots if possible / Inclua logs e screenshots se possível

## 📝 Changelog

### v1.0.0 (2025-08-06)
- ✅ Complete SwiftUI graphical interface / Interface gráfica completa em SwiftUI
- ✅ Colorful terminal script / Script de terminal colorido
- ✅ Automatic EFI discovery / Descoberta automática de EFIs
- ✅ Safe mount/unmount operations / Operações seguras de montagem/desmontagem
- ✅ Finder integration / Integração com Finder
- ✅ Integrated help system / Sistema de ajuda integrado

---

**Developed with ❤️ for the macOS community**  
**Desenvolvido com ❤️ para a comunidade macOS**
