# 🎉 EFI Mount Tool v1.1.3 - Desmontagem Simplificada

![Release](https://img.shields.io/badge/🚀_RELEASE-v1.1.3-FF6B6B?style=for-the-badge)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange?style=for-the-badge&logo=swift)
![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue?style=for-the-badge&logo=apple)
![Universal](https://img.shields.io/badge/Universal_Binary-Intel_%2B_ARM64-purple?style=for-the-badge)

**Release com melhorias de usabilidade: desmontagem sem solicitação de senha**

---

## ✨ **Novidades v1.1.3**

### 🔓 **Desmontagem Simplificada**
- ✅ **Sem solicitação de senha** para desmontar partições EFI
- ✅ **Múltiplas tentativas** automáticas de desmontagem
- ✅ **Desmontagem inteligente** com fallbacks
- ✅ **Experiência mais fluida** para o usuário

### 📜 **Sistema de Scroll Inteligente**
- ✅ **ScrollView** na lista de partições EFI
- ✅ **Navegação suave** para múltiplas partições
- ✅ **Interface adaptativa** que cresce conforme necessário
- ✅ **Performance otimizada** com LazyVStack

### 🏗️ **Binário Universal**
- ✅ **Intel x86_64**: ~780KB - Execução nativa em Macs Intel
- ✅ **Apple Silicon ARM64**: ~790KB - Execução nativa em M1/M2/M3
- ✅ **Universal Binary**: 1.6MB - Ambas arquiteturas em um só arquivo
- ⚡ **Performance otimizada** sem necessidade de Rosetta

---

## 🔧 **Detalhes Técnicos**

### 🔓 **Sistema de Desmontagem Inteligente**
| Tentativa | Método | Privilégios | Descrição |
|-----------|--------|-------------|-----------|
| **1ª** | `diskutil unmount` | Usuário | Desmontagem simples |
| **2ª** | `diskutil unmount force` | Usuário | Desmontagem forçada |
| **3ª** | `diskutil eject` | Usuário | Ejeção do dispositivo |

### 📊 **Interface**
| Componente | Antes | Agora |
|------------|-------|-------|
| **Desmontagem** | Sempre pede senha | Tentativas automáticas sem senha |
| **Lista de Partições** | ForEach estático | ScrollView + LazyVStack |
| **Altura Máxima** | Ilimitada | 300px com scroll |
| **Usabilidade** | Limitada | Experiência fluida |

### ⚙️ **Especificações**
- **Linguagem**: Swift 5.9+
- **Framework**: SwiftUI
- **Sistema**: macOS 13.0 (Ventura)+
- **Arquitetura**: **Universal Binary** (Intel x86_64 + Apple Silicon ARM64)
- **Execução**: Nativa em ambas arquiteturas (sem Rosetta)

---

## 🚀 **Instalação**

### 📥 **Download Direto**
1. Baixe `EFI-Mount-Tool-Universal-v1.1.3.zip` (531KB)
2. Extraia o arquivo
3. Mova para `/Applications`
4. Execute o app

> 💡 **Binário Universal**: Execução nativa em Intel Macs e Apple Silicon
> 
> 🔓 **Nova experiência**: Desmontagem sem solicitação de senha

### 🔨 **Compilação**
```bash
git clone https://github.com/menthorz/efi-mount-tool.git
cd efi-mount-tool/EFI-Swift-GUI
swift build --configuration release --arch arm64
swift build --configuration release --arch x86_64
# Use o script build-universal-v1.1.3.sh para build completo
```

---

## 🎯 **Funcionalidades**

### 🏗️ **Gestão de Partições EFI**
- 🔍 **Descoberta automática** de partições EFI
- 🔧 **Montagem segura** (com privilégios quando necessário)
- 🔓 **Desmontagem simplificada** (sem solicitação de senha)
- 📂 **Abertura no Finder** com um clique
- 📊 **Status visual** em tempo real

### 🎨 **Interface Nativa**
- 🖱️ **Scroll responsivo** para múltiplas partições
- 📱 **Design responsivo** do macOS
- 🌈 **Feedback visual** durante operações
- ♿ **Acessibilidade completa**

---

## 🔄 **Changelog v1.1.3**

### ✨ **Adicionado**
- Sistema de desmontagem sem solicitação de senha
- Múltiplas tentativas automáticas de desmontagem
- Fallbacks inteligentes para desmontagem (force, eject)
- Melhor detecção de status de montagem

### 🔧 **Melhorado**
- Experiência do usuário mais fluida
- Redução de interrupções por diálogos de senha
- Performance na desmontagem de partições
- Mensagens de status mais claras

### 🐛 **Corrigido**
- Solicitação desnecessária de senha para desmontagem
- Falhas em desmontagem de partições não complexas
- Experiência interrompida por múltiplos diálogos

---

## 📋 **Requisitos do Sistema**

| Componente | Especificação |
|------------|---------------|
| **Sistema** | macOS 13.0 (Ventura)+ |
| **Processador** | Intel x86_64 OU Apple Silicon ARM64 |
| **Memória** | 256MB disponível |
| **Espaço** | 10MB livres |
| **Permissões** | Administrador (apenas para montagem) |

---

## 🔮 **Próximas Versões**

### v1.2.0 (Planejada)
- [ ] Menu contextual nas partições
- [ ] Atalhos de teclado
- [ ] Logs detalhados de operações
- [ ] Configurações personalizáveis
- [ ] Notificações do sistema

### v2.0.0 (Visão)
- [ ] Suporte a outros tipos de partição
- [ ] Interface dark mode
- [ ] Sincronização em nuvem
- [ ] Plugin system
- [ ] Automação com AppleScript

---

## 🎯 **Comparação de Versões**

| Feature | v1.1.2 | v1.1.3 |
|---------|--------|--------|
| **Scroll na Lista** | ✅ | ✅ |
| **Binário Universal** | ✅ | ✅ |
| **Montagem** | Pede senha | Pede senha |
| **Desmontagem** | Pede senha | **Sem senha** |
| **Tentativas Múltiplas** | ❌ | ✅ |
| **Experiência UX** | Boa | **Excelente** |

---

## 🙏 **Créditos**

**Desenvolvido por**: [Raphael (@menthorz)](https://github.com/menthorz)

**Tecnologias**: Swift, SwiftUI, Foundation, diskutil

---

## 🔗 **Links**

- 🏠 [Repositório](https://github.com/menthorz/efi-mount-tool)
- 📥 [Releases](https://github.com/menthorz/efi-mount-tool/releases)
- 🐛 [Issues](https://github.com/menthorz/efi-mount-tool/issues)

---

⭐ **Se este projeto foi útil, considere dar uma star!**

*Desenvolvido com ❤️ e Swift - v1.1.3 - Agosto 2025*
