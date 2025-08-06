#!/bin/bash

# Script para criar release no GitHub
# Para EFI Swift GUI v1.1.1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

VERSION="1.1.1"
TAG="v$VERSION"
APP_NAME="EFI Swift GUI.app"
ZIP_NAME="EFI-Swift-GUI-$VERSION.zip"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              ${WHITE}GITHUB RELEASE CREATOR v$VERSION${BLUE}                ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se o app foi compilado
if [[ ! -d "$APP_NAME" ]]; then
    echo -e "${RED}❌ App '$APP_NAME' não encontrado!${NC}"
    echo -e "${YELLOW}Execute ./build.sh primeiro${NC}"
    exit 1
fi

echo -e "${CYAN}📦 Criando arquivo ZIP para release...${NC}"

# Remover zip anterior se existir
rm -f "$ZIP_NAME"

# Criar ZIP do app
if zip -r "$ZIP_NAME" "$APP_NAME" -x "*.DS_Store"; then
    echo -e "${GREEN}✅ ZIP criado: $ZIP_NAME${NC}"
else
    echo -e "${RED}❌ Erro ao criar ZIP${NC}"
    exit 1
fi

# Calcular tamanho e hash
ZIP_SIZE=$(du -sh "$ZIP_NAME" | cut -f1)
ZIP_HASH=$(shasum -a 256 "$ZIP_NAME" | cut -d' ' -f1)

echo ""
echo -e "${CYAN}📊 Informações do arquivo:${NC}"
echo -e "   • Arquivo: $ZIP_NAME"
echo -e "   • Tamanho: $ZIP_SIZE"
echo -e "   • SHA256: $ZIP_HASH"
echo ""

# Verificar se estamos em um repo git
if [[ ! -d ".git" ]]; then
    echo -e "${RED}❌ Não é um repositório Git!${NC}"
    echo -e "${YELLOW}Navegue para o diretório do repositório Git${NC}"
    exit 1
fi

echo -e "${YELLOW}🏷️ Criando tag Git...${NC}"

# Criar tag
if git tag -a "$TAG" -m "Release $VERSION - Ícone personalizado

✨ Novidades na versão $VERSION:
• 🎨 Ícone personalizado integrado
• 📱 Interface aprimorada com branding
• 🔧 Melhorias na integração do sistema
• 🚀 Performance otimizada

📦 Componentes incluídos:
• Interface Swift nativa
• Sistema de bandejas (system tray)
• Shell script integrado 
• Suporte universal (Intel + Apple Silicon)
• Notificações do sistema
• Atalhos de teclado

🔧 Funcionalidades:
• Montagem/desmontagem automática
• Detecção dinâmica de partições EFI
• Interface intuitiva
• Logs detalhados
• Backup automático

Arquivo: $ZIP_NAME
Tamanho: $ZIP_SIZE
SHA256: $ZIP_HASH"; then
    echo -e "${GREEN}✅ Tag $TAG criada${NC}"
else
    echo -e "${YELLOW}⚠️ Tag já existe ou erro na criação${NC}"
fi

echo -e "${YELLOW}📤 Enviando para o GitHub...${NC}"

# Push da tag
if git push origin "$TAG"; then
    echo -e "${GREEN}✅ Tag enviada para o GitHub${NC}"
else
    echo -e "${RED}❌ Erro ao enviar tag${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Release $VERSION criado com sucesso!${NC}"
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    ${WHITE}RESUMO DO RELEASE${BLUE}                       ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${CYAN}Versão:${NC} $VERSION"
echo -e "${BLUE}║${NC} ${CYAN}Tag:${NC} $TAG"
echo -e "${BLUE}║${NC} ${CYAN}Arquivo:${NC} $ZIP_NAME"
echo -e "${BLUE}║${NC} ${CYAN}Tamanho:${NC} $ZIP_SIZE"
echo -e "${BLUE}║${NC}"
echo -e "${BLUE}║${NC} ${WHITE}Principais melhorias:${NC}"
echo -e "${BLUE}║${NC}   • Ícone personalizado integrado"
echo -e "${BLUE}║${NC}   • Interface com branding aprimorado"  
echo -e "${BLUE}║${NC}   • Funcionalidades completas"
echo -e "${BLUE}║${NC}   • Suporte universal (Intel + ARM)"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}🌐 Para completar o release:${NC}"
echo -e "${WHITE}1. Acesse: https://github.com/seu-usuario/seu-repo/releases${NC}"
echo -e "${WHITE}2. Edite a tag $TAG${NC}"
echo -e "${WHITE}3. Anexe o arquivo: $ZIP_NAME${NC}"
echo -e "${WHITE}4. Publique o release${NC}"
echo ""

echo -e "${GREEN}✅ Release preparado com sucesso!${NC}"
