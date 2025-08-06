#!/bin/bash

# EFI Mount Tool - GitHub Release Script
# Este script ajuda a preparar e fazer upload do release para o GitHub

set -e

PROJECT_NAME="EFI Mount Tool"
VERSION="v1.1.0"
RELEASE_ZIP="EFI-Mount-Tool-v1.1.0-Universal.zip"
REPO_URL="https://github.com/menthorz/efi-mount-tool"

echo "🚀 GitHub Release Preparation Script"
echo "======================================"
echo ""

# Verificar se os arquivos necessários existem
echo "📋 Checking required files..."

if [ ! -f "$RELEASE_ZIP" ]; then
    echo "❌ Release ZIP not found: $RELEASE_ZIP"
    exit 1
fi

if [ ! -f "README.md" ]; then
    echo "❌ README.md not found"
    exit 1
fi

if [ ! -f "LICENSE" ]; then
    echo "❌ LICENSE not found"
    exit 1
fi

if [ ! -f "RELEASE-NOTES.md" ]; then
    echo "❌ RELEASE-NOTES.md not found"
    exit 1
fi

echo "✅ All required files found"
echo ""

# Mostrar informações do release
echo "📊 Release Information:"
echo "----------------------"
echo "Project: $PROJECT_NAME"
echo "Version: $VERSION"
echo "ZIP Size: $(ls -lh $RELEASE_ZIP | awk '{print $5}')"
echo "Repository: $REPO_URL"
echo ""

# Contar arquivos no ZIP
ZIP_FILES=$(unzip -l "$RELEASE_ZIP" | tail -1 | awk '{print $2}')
echo "📦 Files in release: $ZIP_FILES"
echo ""

# Verificar estrutura do projeto
echo "🏗️ Project Structure:"
echo "-------------------"
find . -type f -name "*.md" -o -name "*.sh" -o -name "*.swift" -o -name "*.zip" | head -10
echo ""

# Mostrar comandos para GitHub
echo "📝 GitHub Commands:"
echo "-------------------"
echo ""
echo "1️⃣ Initialize git repository (if not done):"
echo "git init"
echo "git add ."
echo "git commit -m \"Initial release v1.0.0\""
echo "git branch -M main"
echo "git remote add origin $REPO_URL.git"
echo "git push -u origin main"
echo ""

echo "2️⃣ Create GitHub release:"
echo "git tag $VERSION"
echo "git push origin $VERSION"
echo ""

echo "3️⃣ Upload release assets:"
echo "- Go to: $REPO_URL/releases"
echo "- Click 'Create a new release'"
echo "- Tag: $VERSION"
echo "- Title: $PROJECT_NAME $VERSION"
echo "- Description: Copy from RELEASE-NOTES.md"
echo "- Upload: $RELEASE_ZIP"
echo ""

echo "4️⃣ Or use GitHub CLI (if installed):"
echo "gh release create $VERSION $RELEASE_ZIP --title \"$PROJECT_NAME $VERSION\" --notes-file RELEASE-NOTES.md"
echo ""

# Verificar se gh CLI está instalado
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI detected! You can use the gh command above."
    echo ""
    echo "🤖 Want to create the release automatically? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Creating GitHub release..."
        gh release create "$VERSION" "$RELEASE_ZIP" \
            --title "$PROJECT_NAME $VERSION" \
            --notes-file RELEASE-NOTES.md \
            --draft
        echo "✅ Draft release created! Review and publish on GitHub."
    fi
else
    echo "ℹ️ GitHub CLI not installed. Use manual steps above."
fi

echo ""
echo "🎉 Release preparation completed!"
echo "📁 Files ready for GitHub:"
echo "   - README.md (bilingual documentation)"
echo "   - LICENSE (MIT)"
echo "   - RELEASE-NOTES.md (detailed changelog)"
echo "   - $RELEASE_ZIP (290KB release package)"
echo ""
echo "🔗 Next steps:"
echo "   1. Push code to GitHub repository"
echo "   2. Create release using tag $VERSION"
echo "   3. Upload $RELEASE_ZIP as release asset"
echo "   4. Copy release notes from RELEASE-NOTES.md"
echo ""
echo "Happy releasing! 🚀"
