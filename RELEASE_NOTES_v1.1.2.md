# 🎉 EFI Mount Tool v1.1.2 - Interface Melhorada

![Release](https://img.shields.io/badge/🚀_RELEASE-v1.1.2-FF6B6B?style=for-the-badge)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange?style=for-the-badge&logo=swift)
![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue?style=for-the-badge&logo=apple)

**Release com melhorias de usabilidade para múltiplas partições EFI**

---

## ✨ **Novidades v1.1.2**

### 📜 **Sistema de Scroll Inteligente**
- ✅ **ScrollView** na lista de partições EFI
- ✅ **Navegação suave** para múltiplas partições
- ✅ **Interface adaptativa** que cresce conforme necessário
- ✅ **Performance otimizada** com LazyVStack

### 🎯 **Melhorias de Usabilidade**
- 🖱️ **Scroll responsivo** para usuários com muitos discos
- 📱 **Altura máxima** limitada para manter proporções
- ⚡ **Carregamento sob demanda** de partições
- 🎨 **Design consistente** com padrões macOS

---

## 🔧 **Detalhes Técnicos**

### 📊 **Interface**
| Componente | Antes | Agora |
|------------|-------|-------|
| **Lista de Partições** | ForEach estático | ScrollView + LazyVStack |
| **Altura Máxima** | Ilimitada | 300px com scroll |
| **Performance** | Carrega tudo | Carregamento lazy |
| **Usabilidade** | Limitada | Scroll infinito |

### ⚙️ **Especificações**
- **Linguagem**: Swift 5.9+
- **Framework**: SwiftUI
- **Sistema**: macOS 13.0 (Ventura)+
- **Arquitetura**: Universal (Intel + Apple Silicon)

---

## 🚀 **Instalação**

### 📥 **Download Direto**
1. Baixe `EFI-Mount-Tool-v1.1.2.zip`
2. Extraia o arquivo
3. Mova para `/Applications`
4. Execute o app

### 🔨 **Compilação**
```bash
git clone https://github.com/menthorz/efi-mount-tool.git
cd efi-mount-tool/EFI-Swift-GUI
swift build
```

---

## 🎯 **Funcionalidades**

### 🏗️ **Gestão de Partições EFI**
- 🔍 **Descoberta automática** de partições EFI
- 🔧 **Montagem/desmontagem** segura
- 📂 **Abertura no Finder** com um clique
- 📊 **Status visual** em tempo real

### 🎨 **Interface Nativa**
- 🖱️ **Drag & Drop** intuitivo
- 📱 **Design responsivo** do macOS
- 🌈 **Feedback visual** durante operações
- ♿ **Acessibilidade completa**

---

## 🔄 **Changelog v1.1.2**

### ✨ **Adicionado**
- ScrollView na lista de partições EFI
- LazyVStack para performance otimizada
- Altura máxima configurável (300px)
- Suporte para navegação com muitas partições

### 🔧 **Melhorado**
- Interface mais responsiva
- Melhor experiência com múltiplos discos
- Performance de carregamento
- Consistência visual

### 🐛 **Corrigido**
- Interface não responsiva com muitas partições
- Layout quebrado em listas longas
- Performance degradada com muitos itens

---

## 📋 **Requisitos do Sistema**

| Componente | Especificação |
|------------|---------------|
| **Sistema** | macOS 13.0 (Ventura)+ |
| **Processador** | Intel x86_64 OU Apple Silicon ARM64 |
| **Memória** | 256MB disponível |
| **Espaço** | 10MB livres |
| **Permissões** | Administrador (para montagem) |

---

## 🔮 **Próximas Versões**

### v1.2.0 (Planejada)
- [ ] Menu contextual nas partições
- [ ] Atalhos de teclado
- [ ] Logs detalhados de operações
- [ ] Configurações personalizáveis

### v2.0.0 (Visão)
- [ ] Suporte a outros tipos de partição
- [ ] Interface dark mode
- [ ] Sincronização em nuvem
- [ ] Plugin system

---

## 🙏 **Créditos**

**Desenvolvido por**: [Raphael (@menthorz)](https://github.com/menthorz)

**Tecnologias**: Swift, SwiftUI, Foundation

---

## 🔗 **Links**

- 🏠 [Repositório](https://github.com/menthorz/efi-mount-tool)
- 📥 [Releases](https://github.com/menthorz/efi-mount-tool/releases)
- 🐛 [Issues](https://github.com/menthorz/efi-mount-tool/issues)

---

⭐ **Se este projeto foi útil, considere dar uma star!**

*Desenvolvido com ❤️ e Swift - v1.1.2 - Agosto 2025*
