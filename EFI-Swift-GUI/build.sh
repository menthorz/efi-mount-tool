#!/bin/bash

# Build script para EFI Swift GUI

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║              ${WHITE}EFI SWIFT GUI - BUILD SCRIPT${BLUE}                 ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se estamos no diretório correto
if [[ ! -f "Package.swift" ]]; then
    echo -e "${RED}❌ Package.swift não encontrado!${NC}"
    echo -e "${YELLOW}Execute este script no diretório EFI-Swift-GUI${NC}"
    exit 1
fi

echo -e "${YELLOW}🔨 Compilando projeto Swift...${NC}"

# Compilar o projeto
if swift build; then
    echo ""
    echo -e "${GREEN}✅ Compilação concluída com sucesso!${NC}"
else
    echo ""
    echo -e "${RED}❌ Erro na compilação!${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}📦 Criando app bundle...${NC}"

# Criar diretório do app bundle
APP_NAME="EFI Swift GUI.app"
APP_DIR="$APP_NAME/Contents"
rm -rf "$APP_NAME"
mkdir -p "$APP_DIR"/{MacOS,Resources}

# Copiar executável
if [[ -f ".build/debug/EFI-Swift-GUI" ]]; then
    cp ".build/debug/EFI-Swift-GUI" "$APP_DIR/MacOS/EFI-Swift-GUI"
    chmod +x "$APP_DIR/MacOS/EFI-Swift-GUI"
    echo -e "${GREEN}✅ Executável copiado${NC}"
else
    echo -e "${RED}❌ Executável não encontrado!${NC}"
    exit 1
fi

# Copiar shell script para o bundle
cp "../efi_mount.sh" "$APP_DIR/Resources/"
chmod +x "$APP_DIR/Resources/efi_mount.sh"
echo -e "${GREEN}✅ Shell script incluído${NC}"

# Criar Info.plist
cat > "$APP_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>EFI-Swift-GUI</string>
    <key>CFBundleIdentifier</key>
    <string>com.efimount.swift-gui</string>
    <key>CFBundleName</key>
    <string>EFI Swift GUI</string>
    <key>CFBundleDisplayName</key>
    <string>EFI Swift GUI</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
</dict>
</plist>
EOF

echo -e "${GREEN}✅ Info.plist criado${NC}"

# Calcular tamanho
app_size=$(du -sh "$APP_NAME" | cut -f1)
executable_size=$(du -sh "$APP_DIR/MacOS/EFI-Swift-GUI" | cut -f1)

echo ""
echo -e "${GREEN}🎉 App bundle criado com sucesso!${NC}"
echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    ${WHITE}RESUMO DO BUILD${BLUE}                         ║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${CYAN}App Bundle:${NC} $APP_NAME"
echo -e "${BLUE}║${NC} ${CYAN}Tamanho Total:${NC} $app_size"
echo -e "${BLUE}║${NC} ${CYAN}Executável:${NC} $executable_size"
echo -e "${BLUE}║${NC} ${CYAN}Plataforma:${NC} macOS 13.0+"
echo -e "${BLUE}║${NC}"
echo -e "${BLUE}║${NC} ${WHITE}Componentes incluídos:${NC}"
echo -e "${BLUE}║${NC}   • Interface Swift nativa"
echo -e "${BLUE}║${NC}   • Shell script integrado"
echo -e "${BLUE}║${NC}   • Funcionalidades completas"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}🚀 Para testar o app:${NC}"
echo -e "${WHITE}open '$APP_NAME'${NC}"
echo ""

# Perguntar se quer executar
echo -e "${YELLOW}Deseja executar o app agora? (s/n):${NC} \c"
read -r run_app

if [[ "$run_app" =~ ^[SsYy]$ ]]; then
    echo -e "${CYAN}Executando app...${NC}"
    open "$APP_NAME"
fi

echo ""
echo -e "${GREEN}✅ Build concluído!${NC}"
