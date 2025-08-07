# 🚀 EFI Mount Tool v1.2.1 - Release Completo

## 🇧🇷 Português

### 📅 Informações da Versão
- **Versão**: v1.2.1
- **Data de Lançamento**: 7 de Agosto de 2025
- **Tipo**: Atualização de Experiência do Usuário
- **Arquitetura**: Binário Universal (ARM64 + x86_64)
- **Compatibilidade**: macOS 12.0+

---

### 🎯 Principais Diferenciais da v1.2.1

#### 🏷️ Revolução na Exibição de Informações
**Antes (v1.2.0):**
```
Partição: /dev/disk0s1
Tamanho: 500107862016 bytes
```

**Agora (v1.2.1):**
```
Partição: /dev/disk0s1
Disco: Samsung SSD 980 PRO
```

#### ✨ Principais Melhorias

1. **📱 Nomes Reais de Fabricantes**
   - Substituição completa de bytes por nomes significativos
   - Exemplos: "Samsung SSD 980 PRO", "APPLE SSD AP0256M", "WD Blue SN570"
   - Identificação instantânea do hardware físico
   - Interface mais intuitiva e profissional

2. **🔧 Gerenciamento Centralizado de Versão**
   - Nova estrutura `AppConstants` para controle de versão
   - Versão exibida consistentemente em todos os componentes
   - Menu Bar, Sistema de Ajuda e Informações do Sistema atualizados
   - Manutenção simplificada do código

3. **⚡ Descoberta Aprimorada de Discos**
   - Extração automática de informações do fabricante via `diskutil`
   - Comando `diskutil info` para obter "Device / Media Name"
   - Análise inteligente de dados do sistema
   - Fallback seguro para casos especiais

4. **🎨 Interface Refinada**
   - Exibição de versão em tempo real
   - Tooltips e mensagens atualizadas
   - Consistência visual mantida
   - Experiência do usuário aprimorada

---

### 📦 Arquivos de Download

| Arquivo | Descrição | Tamanho | Recomendado Para |
|---------|-----------|---------|------------------|
| **EFI-Mount-Tool-App-Bundle-v1.2.1.zip** | App completo com ícone personalizado | 2.6 MB | Instalação completa no macOS |
| **EFI-Mount-Tool-Universal-v1.2.1.zip** | Executável universal standalone | 407 KB | Uso portátil ou integração |

---

### 🔄 Changelog Técnico

#### Adicionado
- Campo `diskName` no modelo `EFIPartition`
- Estrutura `AppConstants` para constantes da aplicação
- Extração automática de nomes de fabricantes
- Exibição de versão em todas as interfaces

#### Modificado
- Lógica de descoberta no `EFIService.swift`
- Interface principal: substituição de tamanho por nome
- Componentes de UI: `ContentView`, `MenuBarManager`, `HelpView`, `SystemInfoView`
- Script de build atualizado para v1.2.1

#### Removido
- Exibição de bytes nas listas de partições
- Arquivos relacionados à v1.2.0

---

### 🛠️ Especificações Técnicas

- **Framework**: SwiftUI nativo
- **Linguagem**: Swift 5.9+
- **Requisitos**: macOS 12.0 (Monterey) ou superior
- **Arquiteturas**: ARM64 (Apple Silicon) + x86_64 (Intel)
- **Bundle ID**: `com.menthorz.efi-mount-tool`
- **Assinatura**: Não assinado (requer bypass do Gatekeeper)

---

### 🎯 Casos de Uso Melhorados

1. **Administradores de Sistema**
   - Identificação rápida de discos em múltiplas máquinas
   - Relatórios mais claros e profissionais
   - Redução de erros operacionais

2. **Desenvolvedores**
   - Trabalho com múltiplas partições EFI
   - Debugging facilitado com nomes reais
   - Workflows mais eficientes

3. **Usuários Corporativos**
   - Interface profissional sem jargões técnicos
   - Adequado para ambientes empresariais
   - Documentação e suporte melhorados

---

## 🇺🇸 English

### 📅 Version Information
- **Version**: v1.2.1
- **Release Date**: August 7, 2025
- **Type**: User Experience Update
- **Architecture**: Universal Binary (ARM64 + x86_64)
- **Compatibility**: macOS 12.0+

---

### 🎯 Key Differentials in v1.2.1

#### 🏷️ Information Display Revolution
**Before (v1.2.0):**
```
Partition: /dev/disk0s1
Size: 500107862016 bytes
```

**Now (v1.2.1):**
```
Partition: /dev/disk0s1
Disk: Samsung SSD 980 PRO
```

#### ✨ Major Improvements

1. **📱 Real Manufacturer Names**
   - Complete replacement of bytes with meaningful names
   - Examples: "Samsung SSD 980 PRO", "APPLE SSD AP0256M", "WD Blue SN570"
   - Instant physical hardware identification
   - More intuitive and professional interface

2. **🔧 Centralized Version Management**
   - New `AppConstants` structure for version control
   - Version displayed consistently across all components
   - Menu Bar, Help System, and System Information updated
   - Simplified code maintenance

3. **⚡ Enhanced Disk Discovery**
   - Automatic manufacturer information extraction via `diskutil`
   - `diskutil info` command to get "Device / Media Name"
   - Intelligent system data analysis
   - Safe fallback for edge cases

4. **🎨 Refined Interface**
   - Real-time version display
   - Updated tooltips and messages
   - Maintained visual consistency
   - Enhanced user experience

---

### 📦 Download Files

| File | Description | Size | Recommended For |
|------|-------------|------|-----------------|
| **EFI-Mount-Tool-App-Bundle-v1.2.1.zip** | Complete app with custom icon | 2.6 MB | Full macOS installation |
| **EFI-Mount-Tool-Universal-v1.2.1.zip** | Universal standalone executable | 407 KB | Portable use or integration |

---

### 🔄 Technical Changelog

#### Added
- `diskName` field in `EFIPartition` model
- `AppConstants` structure for application constants
- Automatic manufacturer name extraction
- Version display across all interfaces

#### Modified
- Discovery logic in `EFIService.swift`
- Main interface: size replaced with name
- UI components: `ContentView`, `MenuBarManager`, `HelpView`, `SystemInfoView`
- Build script updated to v1.2.1

#### Removed
- Byte display in partition lists
- v1.2.0 related files

---

### 🛠️ Technical Specifications

- **Framework**: Native SwiftUI
- **Language**: Swift 5.9+
- **Requirements**: macOS 12.0 (Monterey) or later
- **Architectures**: ARM64 (Apple Silicon) + x86_64 (Intel)
- **Bundle ID**: `com.menthorz.efi-mount-tool`
- **Signature**: Unsigned (requires Gatekeeper bypass)

---

### 🎯 Enhanced Use Cases

1. **System Administrators**
   - Quick disk identification across multiple machines
   - Clearer and more professional reports
   - Reduced operational errors

2. **Developers**
   - Working with multiple EFI partitions
   - Easier debugging with real names
   - More efficient workflows

3. **Corporate Users**
   - Professional interface without technical jargon
   - Suitable for enterprise environments
   - Improved documentation and support

---

## 🔗 Links Importantes / Important Links

- **Repository**: [efi-mount-tool](https://github.com/menthorz/efi-mount-tool)
- **Download v1.2.1**: [Release Page](https://github.com/menthorz/efi-mount-tool/releases/tag/v1.2.1)
- **Issues**: [Bug Reports](https://github.com/menthorz/efi-mount-tool/issues)
- **Discussions**: [Community](https://github.com/menthorz/efi-mount-tool/discussions)

---

## 📝 Nota Final / Final Note

**🇧🇷 PT-BR**: A versão 1.2.1 representa um marco significativo na evolução do EFI Mount Tool, priorizando a experiência do usuário sem comprometer a funcionalidade técnica. A substituição de informações técnicas por dados mais intuitivos torna a ferramenta acessível para um público mais amplo, mantendo toda a robustez e confiabilidade das versões anteriores.

**🇺🇸 EN**: Version 1.2.1 represents a significant milestone in EFI Mount Tool's evolution, prioritizing user experience without compromising technical functionality. The replacement of technical information with more intuitive data makes the tool accessible to a broader audience while maintaining all the robustness and reliability of previous versions.

---

*Desenvolvido com ❤️ para a comunidade macOS / Built with ❤️ for the macOS community*
