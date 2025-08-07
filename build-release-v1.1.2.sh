#!/bin/bash

# EFI Mount Tool - Build Script para Release v1.1.2
# Criado para gerar release com interface melhorada

set -e

echo "🚀 Iniciando build do EFI Mount Tool v1.1.2..."

# Navegar para o diretório do projeto Swift
cd "EFI-Swift-GUI"

# Limpar builds anteriores
echo "🧹 Limpando builds anteriores..."
rm -rf .build/
rm -rf "EFI Swift GUI.app"

# Build do projeto
echo "🔨 Compilando aplicação..."
swift build --configuration release

# Criar estrutura do app bundle
echo "📦 Criando app bundle..."
APP_NAME="EFI Mount Tool"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copiar executável
echo "📋 Copiando executável..."
cp .build/release/EFI-Swift-GUI "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Criar Info.plist
echo "📄 Criando Info.plist..."
cat > "${CONTENTS_DIR}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.menthorz.efi-mount-tool</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleVersion</key>
    <string>1.1.2</string>
    <key>CFBundleShortVersionString</key>
    <string>1.1.2</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>© 2025 Raphael (@menthorz). Todos os direitos reservados.</string>
    <key>NSMainStoryboardFile</key>
    <string>Main</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
</dict>
</plist>
EOF

# Copiar ícone se existir
if [ -f "../NewAppIcon.iconset/icon_512x512.png" ]; then
    echo "🎨 Copiando ícone..."
    cp "../NewAppIcon.iconset/icon_512x512.png" "${RESOURCES_DIR}/AppIcon.png"
fi

# Informações do build
echo "📊 Informações do build:"
EXECUTABLE_PATH="${MACOS_DIR}/${APP_NAME}"
if [ -f "${EXECUTABLE_PATH}" ]; then
    SIZE=$(ls -lh "${EXECUTABLE_PATH}" | awk '{print $5}')
    echo "   📏 Tamanho do executável: ${SIZE}"
    
    # Verificar arquitetura
    if command -v file > /dev/null; then
        ARCH=$(file "${EXECUTABLE_PATH}" | cut -d: -f2)
        echo "   🏗️  Arquitetura: ${ARCH}"
    fi
fi

# Criar ZIP do release
echo "📦 Criando arquivo ZIP para release..."
cd ..
ZIP_NAME="EFI-Mount-Tool-v1.1.2.zip"
rm -f "${ZIP_NAME}"

cd "EFI-Swift-GUI"
zip -r "../${ZIP_NAME}" "${APP_BUNDLE}" -x "*.DS_Store*"
cd ..

if [ -f "${ZIP_NAME}" ]; then
    ZIP_SIZE=$(ls -lh "${ZIP_NAME}" | awk '{print $5}')
    echo "✅ Release criado: ${ZIP_NAME} (${ZIP_SIZE})"
else
    echo "❌ Erro ao criar ZIP do release"
    exit 1
fi

echo ""
echo "🎉 Build concluído com sucesso!"
echo "📦 Release: ${ZIP_NAME}"
echo "📁 App: EFI-Swift-GUI/${APP_BUNDLE}"
echo ""
echo "🔄 Próximos passos:"
echo "   1. Testar a aplicação: open 'EFI-Swift-GUI/${APP_BUNDLE}'"
echo "   2. Commit e push das mudanças"
echo "   3. Criar tag v1.1.2"
echo "   4. Fazer upload do ${ZIP_NAME} no GitHub"
echo ""
