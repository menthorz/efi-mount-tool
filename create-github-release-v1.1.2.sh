#!/bin/bash

# Script para criar release v1.1.2 no GitHub
# EFI Mount Tool - Interface Melhorada

echo "🚀 Criando release v1.1.2 do EFI Mount Tool..."

# Informações da release
VERSION="v1.1.2"
TITLE="🎉 EFI Mount Tool v1.1.2 - Interface Melhorada"
ZIP_FILE="EFI-Mount-Tool-v1.1.2.zip"

# Descrição da release
DESCRIPTION="## ✨ **Interface Melhorada com Sistema de Scroll**

### 🆕 **Principais Novidades:**
- ✅ **ScrollView** na lista de partições EFI
- ✅ **Navegação suave** para múltiplas partições  
- ✅ **LazyVStack** para performance otimizada
- ✅ **Interface adaptativa** que cresce conforme necessário

### 🎯 **Melhorias de Usabilidade:**
- 🖱️ **Scroll responsivo** para usuários com muitos discos
- 📱 **Altura máxima** limitada para manter proporções (300px)
- ⚡ **Carregamento sob demanda** de partições
- 🎨 **Design consistente** com padrões macOS

### 📊 **Especificações da Release:**
- **📦 Tamanho**: 332KB (compactado)
- **🏗️ Arquitetura**: ARM64 (Apple Silicon nativo)
- **📱 Sistema**: macOS 13.0 (Ventura) ou superior
- **⚡ Performance**: Otimizada para múltiplas partições

### 🔧 **Problemas Resolvidos:**
- Interface não responsiva com muitas partições EFI
- Layout quebrado em listas longas de dispositivos
- Performance degradada com muitos itens
- Falta de navegação em cenários com múltiplos discos

### 🚀 **Instalação:**
1. Baixe o arquivo \`${ZIP_FILE}\`
2. Extraia o conteúdo
3. Mova \`EFI Mount Tool.app\` para a pasta Applications
4. Execute o aplicativo

### 📋 **Requisitos:**
- macOS 13.0 (Ventura) ou superior
- Processador Apple Silicon (ARM64) ou Intel
- Permissões de administrador para montagem de partições

---

**🔄 Changelog Completo:**
- ✅ Adicionado ScrollView na seção de partições
- ✅ Implementado LazyVStack para carregamento otimizado
- ✅ Definida altura máxima configurável (300px)
- ✅ Melhorado suporte para múltiplas partições
- ✅ Atualizado app bundle com novo nome
- ✅ Criado build script automatizado
- ✅ Integrado ícone personalizado

**👨‍💻 Desenvolvido por**: [@menthorz](https://github.com/menthorz)
**🛠️ Tecnologias**: Swift, SwiftUI, Foundation"

echo "📋 Informações da release:"
echo "   🏷️  Tag: ${VERSION}"
echo "   📦 Arquivo: ${ZIP_FILE}"
echo "   📏 Tamanho: $(ls -lh ${ZIP_FILE} 2>/dev/null | awk '{print $5}' || echo 'N/A')"
echo ""

# Verificar se o GitHub CLI está disponível
if command -v gh > /dev/null 2>&1; then
    echo "✅ GitHub CLI detectado"
    echo ""
    echo "🤖 Tentando criar release automaticamente..."
    
    # Criar release
    if gh release create "${VERSION}" "${ZIP_FILE}" \
        --title "${TITLE}" \
        --notes "${DESCRIPTION}" \
        --latest; then
        echo ""
        echo "🎉 Release criado com sucesso!"
        echo "🔗 Acesse: https://github.com/menthorz/efi-mount-tool/releases/tag/${VERSION}"
    else
        echo ""
        echo "❌ Erro ao criar release automaticamente"
        echo "📝 Criação manual necessária"
    fi
else
    echo "⚠️  GitHub CLI não encontrado"
    echo ""
    echo "📝 Para criar a release manualmente:"
    echo "   1. Acesse: https://github.com/menthorz/efi-mount-tool/releases/new"
    echo "   2. Tag: ${VERSION}"
    echo "   3. Título: ${TITLE}"
    echo "   4. Faça upload do arquivo: ${ZIP_FILE}"
    echo "   5. Copie a descrição do arquivo RELEASE_NOTES_v1.1.2.md"
fi

echo ""
echo "📄 Documentação completa disponível em: RELEASE_NOTES_v1.1.2.md"
echo ""
