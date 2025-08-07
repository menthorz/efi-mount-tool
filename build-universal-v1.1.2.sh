#!/bin/bash

# EFI Mount Tool - Build Universal v1.1.2
# Compila para Intel (x86_64) e Apple Silicon (ARM64)

set -e

echo "🚀 Iniciando build universal do EFI Mount Tool v1.1.2..."

# Navegar para o diretório do projeto Swift
cd "EFI-Swift-GUI"

# Limpar builds anteriores
echo "🧹 Limpando builds anteriores..."
rm -rf .build/
rm -rf "EFI Mount Tool.app"

# Detectar arquitetura do sistema
SYSTEM_ARCH=$(uname -m)
echo "🖥️  Arquitetura do sistema: ${SYSTEM_ARCH}"

# Build para ARM64 (Apple Silicon)
echo "🔨 Compilando para ARM64 (Apple Silicon)..."
swift build --configuration release --arch arm64
ARM64_BINARY=".build/arm64-apple-macosx/release/EFI-Swift-GUI"

# Build para x86_64 (Intel)
echo "🔨 Compilando para x86_64 (Intel)..."
swift build --configuration release --arch x86_64
X86_64_BINARY=".build/x86_64-apple-macosx/release/EFI-Swift-GUI"

# Verificar se os binários foram criados
if [ ! -f "${ARM64_BINARY}" ]; then
    echo "❌ Erro: Binário ARM64 não encontrado em ${ARM64_BINARY}"
    exit 1
fi

if [ ! -f "${X86_64_BINARY}" ]; then
    echo "❌ Erro: Binário x86_64 não encontrado em ${X86_64_BINARY}"
    exit 1
fi

# Criar binário universal com lipo
echo "🔗 Criando binário universal com lipo..."
UNIVERSAL_BINARY=".build/universal/EFI-Swift-GUI"
mkdir -p .build/universal

lipo -create "${ARM64_BINARY}" "${X86_64_BINARY}" -output "${UNIVERSAL_BINARY}"

# Verificar arquiteturas do binário universal
echo "🔍 Verificando arquiteturas do binário universal..."
lipo -info "${UNIVERSAL_BINARY}"
file "${UNIVERSAL_BINARY}"

# Criar estrutura do app bundle
echo "📦 Criando app bundle universal..."
APP_NAME="EFI Mount Tool"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

# Remover app bundle anterior se existir
rm -rf "${APP_BUNDLE}"

mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copiar binário universal
echo "📋 Copiando binário universal..."
cp "${UNIVERSAL_BINARY}" "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Criar Info.plist atualizado
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
    <string>EFI</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHumanReadableCopyright</key>
    <string>© 2025 Raphael (@menthorz). Todos os direitos reservados.</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
    <key>LSRequiresNativeExecution</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
EOF

# Copiar ícone se existir
if [ -f "../NewAppIcon.iconset/icon_512x512.png" ]; then
    echo "🎨 Copiando ícone..."
    cp "../NewAppIcon.iconset/icon_512x512.png" "${RESOURCES_DIR}/AppIcon.png"
fi

# Informações detalhadas do build
echo ""
echo "📊 Informações do build universal:"
EXECUTABLE_PATH="${MACOS_DIR}/${APP_NAME}"
if [ -f "${EXECUTABLE_PATH}" ]; then
    SIZE=$(ls -lh "${EXECUTABLE_PATH}" | awk '{print $5}')
    echo "   📏 Tamanho do executável: ${SIZE}"
    
    # Verificar arquiteturas
    echo "   🏗️  Arquiteturas suportadas:"
    lipo -info "${EXECUTABLE_PATH}" | sed 's/^/       /'
    
    # Informações detalhadas de cada arquitetura
    echo "   🔍 Detalhes por arquitetura:"
    if lipo -verify_arch "${EXECUTABLE_PATH}" arm64; then
        ARM64_SIZE=$(ls -lh "${ARM64_BINARY}" | awk '{print $5}')
        echo "       • ARM64 (Apple Silicon): ${ARM64_SIZE}"
    fi
    if lipo -verify_arch "${EXECUTABLE_PATH}" x86_64; then
        X86_64_SIZE=$(ls -lh "${X86_64_BINARY}" | awk '{print $5}')
        echo "       • x86_64 (Intel): ${X86_64_SIZE}"
    fi
fi

# Criar ZIP do release universal
echo ""
echo "📦 Criando arquivo ZIP para release universal..."
cd ..
ZIP_NAME="EFI-Mount-Tool-Universal-v1.1.2.zip"
rm -f "${ZIP_NAME}"

cd "EFI-Swift-GUI"
zip -r "../${ZIP_NAME}" "${APP_BUNDLE}" -x "*.DS_Store*"
cd ..

if [ -f "${ZIP_NAME}" ]; then
    ZIP_SIZE=$(ls -lh "${ZIP_NAME}" | awk '{print $5}')
    echo "✅ Release universal criado: ${ZIP_NAME} (${ZIP_SIZE})"
else
    echo "❌ Erro ao criar ZIP do release"
    exit 1
fi

echo ""
echo "🎉 Build universal concluído com sucesso!"
echo "📦 Release: ${ZIP_NAME}"
echo "📁 App: EFI-Swift-GUI/${APP_BUNDLE}"
echo ""
echo "🔄 Compatibilidade:"
echo "   ✅ Apple Silicon (ARM64) - Execução nativa"
echo "   ✅ Intel Mac (x86_64) - Execução nativa"
echo "   ✅ macOS 13.0 (Ventura) ou superior"
echo ""
echo "🔄 Próximos passos:"
echo "   1. Testar em ambas arquiteturas: open 'EFI-Swift-GUI/${APP_BUNDLE}'"
echo "   2. Verificar compatibilidade: lipo -info 'EFI-Swift-GUI/${APP_BUNDLE}/Contents/MacOS/${APP_NAME}'"
echo "   3. Commit e push das mudanças"
echo "   4. Atualizar release no GitHub com ${ZIP_NAME}"
echo ""
