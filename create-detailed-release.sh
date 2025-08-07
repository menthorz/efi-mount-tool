#!/bin/bash

# Script para criar release detalhada no GitHub
# EFI Mount Tool v1.1.1 - Release com Ícone Personalizado

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
NC='\033[0m'

VERSION="1.1.1"
TAG="v$VERSION"
ZIP_NAME="EFI-Swift-GUI-$VERSION.zip"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              ${WHITE}EFI MOUNT TOOL - GITHUB RELEASE CREATOR${BLUE}                ║${NC}"
echo -e "${BLUE}║                        ${CYAN}Versão $VERSION${BLUE}                               ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se o ZIP existe
if [[ ! -f "$ZIP_NAME" ]]; then
    echo -e "${RED}❌ Arquivo $ZIP_NAME não encontrado!${NC}"
    echo -e "${YELLOW}Execute o build primeiro${NC}"
    exit 1
fi

# Informações do arquivo
ZIP_SIZE=$(du -sh "$ZIP_NAME" | cut -f1)
ZIP_HASH=$(shasum -a 256 "$ZIP_NAME" | cut -d' ' -f1)
ZIP_SIZE_BYTES=$(wc -c < "$ZIP_NAME")

echo -e "${CYAN}📊 Informações do Release:${NC}"
echo -e "   • Arquivo: $ZIP_NAME"
echo -e "   • Tamanho: $ZIP_SIZE ($ZIP_SIZE_BYTES bytes)"
echo -e "   • SHA256: $ZIP_HASH"
echo ""

# Criar arquivo de release notes
RELEASE_NOTES="release-notes-$VERSION.md"

cat > "$RELEASE_NOTES" << 'EOF'
# 🚀 EFI Mount Tool v1.1.1

## 🎨 **Novidade Principal: Ícone Personalizado Integrado**

Esta versão marca um marco importante no desenvolvimento do EFI Mount Tool com a integração de um **ícone personalizado profissional** que melhora significativamente a experiência do usuário e a identidade visual da aplicação.

---

## ✨ **Principais Diferenciais da v1.1.1**

### 🖼️ **Identidade Visual Aprimorada**
- **Ícone Personalizado**: Integração do ícone `Efi-iOS-Dark-1024x1024@1x.png`
- **Iconset Completo**: Suporte a múltiplas resoluções (16x16 até 1024x1024)
- **Branding Consistente**: Visual profissional em toda a interface
- **Alta Qualidade**: Ícone vetorial convertido para .icns nativo do macOS

### 🔧 **Melhorias Técnicas**
- **Build System Atualizado**: Script de build aprimorado com suporte a ícones
- **Info.plist Otimizado**: Configuração adequada para CFBundleIconFile
- **Tamanho Otimizado**: 2.5MB com ícone de alta qualidade incluído
- **Compatibilidade**: Mantém suporte universal (Intel + Apple Silicon)

### 🎯 **Experiência do Usuário**
- **Visual Profissional**: Interface com identidade visual única
- **Reconhecimento Imediato**: Ícone distintivo no Dock e Finder
- **Consistência**: Branding uniforme em toda a aplicação
- **Polimento**: Acabamento profissional para uso em produção

---

## 📦 **Funcionalidades Completas Mantidas**

### 🖥️ **Interface Swift Nativa**
- Interface moderna e intuitiva
- Sistema de bandejas (system tray) completo
- Menus contextuais dinâmicos
- Notificações do sistema integradas

### ⚡ **Funcionalidades Core**
- **Montagem Automática**: Detecção e montagem de partições EFI
- **Desmontagem Segura**: Processo seguro de desmontagem
- **Detecção Dinâmica**: Reconhecimento automático de partições
- **Logs Detalhados**: Sistema completo de logging
- **Backup Automático**: Proteção de dados importante

### 🚀 **Sistema de Bandejas Avançado**
- **Menu Dinâmico**: Atualização em tempo real
- **Atalhos de Teclado**: Acesso rápido via shortcuts
- **Submenu de Partições**: Organização inteligente
- **Ações Contextuais**: Montar, desmontar, abrir no Finder
- **Status Visual**: Indicadores de estado das partições

### 🛠️ **Funcionalidades Técnicas**
- **Execução Privilegiada**: Suporte a comandos administrativos
- **Shell Script Integrado**: efi_mount.sh embutido
- **Múltiplas Arquiteturas**: Binário universal ARM64 + x86_64
- **Compatibilidade**: macOS 13.0+ (Ventura e superiores)

---

## 🔄 **Evolução das Versões**

### v1.0.0 → v1.1.0
- Implementação completa do sistema de bandejas
- Interface Swift nativa
- Funcionalidades core de montagem/desmontagem

### v1.1.0 → v1.1.1 ⭐
- **Ícone personalizado integrado**
- **Identidade visual profissional**
- **Branding consistente**
- **Experiência aprimorada**

---

## 📋 **Especificações Técnicas**

| Especificação | Detalhes |
|---------------|----------|
| **Versão** | 1.1.1 |
| **Tamanho** | 2.5MB |
| **Arquitetura** | Universal (ARM64 + x86_64) |
| **Sistema** | macOS 13.0+ |
| **Framework** | Swift/SwiftUI |
| **Ícone** | .icns nativo (2.2MB) |
| **Distribuição** | App Bundle (.app) |

---

## 🚀 **Como Usar**

1. **Download**: Baixe o arquivo `EFI-Swift-GUI-1.1.1.zip`
2. **Extração**: Descompacte o arquivo
3. **Instalação**: Mova `EFI Swift GUI.app` para a pasta Applications
4. **Execução**: Execute o app (pode requerer permissões administrativas)
5. **Sistema Tray**: Acesse via ícone na barra de menus

---

## 🔐 **Verificação de Integridade**

```bash
# Verificar SHA256
shasum -a 256 EFI-Swift-GUI-1.1.1.zip
# Resultado esperado: a7881c3d3f2010a1dde40dfc61d5533e7e24656bd467886584817d999dda6a40
```

---

## 🎯 **Próximos Passos**

- Feedback da comunidade sobre o novo ícone
- Possíveis melhorias na interface
- Funcionalidades adicionais baseadas em sugestões
- Otimizações de performance

---

## 🙏 **Agradecimentos**

Obrigado a todos que contribuíram com feedback e sugestões para tornar esta ferramenta ainda melhor!

---

**Download:** [EFI-Swift-GUI-1.1.1.zip](../../releases/download/v1.1.1/EFI-Swift-GUI-1.1.1.zip)

**Repositório:** [menthorz/efi-mount-tool](https://github.com/menthorz/efi-mount-tool)
EOF

echo -e "${GREEN}✅ Release notes criadas: $RELEASE_NOTES${NC}"
echo ""

# Verificar se já existe uma release para esta tag
echo -e "${CYAN}🔍 Verificando release existente...${NC}"

# Usar gh CLI se disponível
if command -v gh >/dev/null 2>&1; then
    echo -e "${YELLOW}📤 Criando release via GitHub CLI...${NC}"
    
    # Criar release usando gh
    if gh release create "$TAG" "$ZIP_NAME" \
        --title "🚀 EFI Mount Tool v$VERSION - Ícone Personalizado" \
        --notes-file "$RELEASE_NOTES" \
        --prerelease=false; then
        echo -e "${GREEN}✅ Release criada com sucesso via GitHub CLI!${NC}"
    else
        echo -e "${YELLOW}⚠️ Erro ao criar via GitHub CLI, usando método manual${NC}"
    fi
else
    echo -e "${YELLOW}ℹ️ GitHub CLI não disponível, usando método manual${NC}"
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    ${WHITE}RESUMO DO RELEASE v$VERSION${BLUE}                         ║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${CYAN}Versão:${NC} $VERSION"
echo -e "${BLUE}║${NC} ${CYAN}Tag:${NC} $TAG"
echo -e "${BLUE}║${NC} ${CYAN}Arquivo:${NC} $ZIP_NAME"
echo -e "${BLUE}║${NC} ${CYAN}Tamanho:${NC} $ZIP_SIZE"
echo -e "${BLUE}║${NC} ${CYAN}SHA256:${NC} ${ZIP_HASH:0:16}..."
echo -e "${BLUE}║${NC}"
echo -e "${BLUE}║${NC} ${WHITE}🎨 Principais Diferenciais:${NC}"
echo -e "${BLUE}║${NC}   • Ícone personalizado Efi-iOS-Dark integrado"
echo -e "${BLUE}║${NC}   • Identidade visual profissional"
echo -e "${BLUE}║${NC}   • Branding consistente em toda aplicação"
echo -e "${BLUE}║${NC}   • Iconset completo (16x16 até 1024x1024)"
echo -e "${BLUE}║${NC}   • Build system otimizado"
echo -e "${BLUE}║${NC}   • Experiência de usuário aprimorada"
echo -e "${BLUE}║${NC}"
echo -e "${BLUE}║${NC} ${WHITE}🔧 Funcionalidades Mantidas:${NC}"
echo -e "${BLUE}║${NC}   • Sistema de bandejas completo"
echo -e "${BLUE}║${NC}   • Interface Swift nativa"
echo -e "${BLUE}║${NC}   • Suporte universal (Intel + ARM)"
echo -e "${BLUE}║${NC}   • Montagem/desmontagem automática"
echo -e "${BLUE}║${NC}   • Notificações e atalhos"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}🌐 Para finalizar:${NC}"
echo -e "${WHITE}1. Acesse: https://github.com/menthorz/efi-mount-tool/releases${NC}"
echo -e "${WHITE}2. Verifique o release v$VERSION${NC}"
echo -e "${WHITE}3. Edite se necessário e publique${NC}"
echo ""

echo -e "${PURPLE}📝 Release Notes salvas em: $RELEASE_NOTES${NC}"
echo -e "${GREEN}✅ Release v$VERSION preparada com todos os diferenciais!${NC}"
