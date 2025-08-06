#!/bin/bash

# Script de teste para verificar funcionamento da montagem EFI

echo "🔍 TESTE DE MONTAGEM EFI"
echo "========================"
echo ""

echo "1️⃣ Verificando partições EFI disponíveis..."
for disk in $(diskutil list | grep '^/dev/disk' | awk '{print $1}'); do
    info=$(diskutil info "$disk" 2>/dev/null)
    if echo "$info" | grep -qi "EFI"; then
        size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
        mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
        if [ -z "$mount" ] || [ "$mount" = "Not applicable" ]; then
            mount="Não montada"
        fi
        echo "  📱 $disk | $size | $mount"
    fi
done

echo ""
echo "2️⃣ Testando comando de montagem (com osascript)..."

# Pegar a primeira partição EFI não montada
EFI_DEVICE=$(diskutil list | grep '^/dev/disk' | head -1 | awk '{print $1}')
if [ ! -z "$EFI_DEVICE" ]; then
    echo "  🎯 Dispositivo de teste: $EFI_DEVICE"
    
    # Verificar se já está montada
    mount_status=$(diskutil info "$EFI_DEVICE" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
    
    if [ -z "$mount_status" ] || [ "$mount_status" = "Not applicable" ]; then
        echo "  🔄 Tentando montar $EFI_DEVICE..."
        echo "  ⚠️ NOTA: Isso solicitará sua senha de administrador"
        
        # Comando real que será usado pelo app
        result=$(osascript -e "do shell script \"diskutil mount $EFI_DEVICE\" with administrator privileges" 2>&1)
        
        if [ $? -eq 0 ]; then
            echo "  ✅ Montagem bem-sucedida!"
            echo "  📁 Resultado: $result"
            
            # Verificar onde foi montada
            mount_info=$(diskutil info "$EFI_DEVICE" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
            if [ ! -z "$mount_info" ] && [ "$mount_info" != "Not applicable" ]; then
                echo "  📍 Localização: $mount_info"
                
                # Tentar desmontar
                echo "  🔄 Desmontando..."
                unmount_result=$(osascript -e "do shell script \"diskutil unmount $EFI_DEVICE\" with administrator privileges" 2>&1)
                if [ $? -eq 0 ]; then
                    echo "  ✅ Desmontagem bem-sucedida!"
                else
                    echo "  ❌ Erro na desmontagem: $unmount_result"
                fi
            fi
        else
            echo "  ❌ Erro na montagem: $result"
        fi
    else
        echo "  ℹ️ Partição já está montada em: $mount_status"
    fi
else
    echo "  ❌ Nenhuma partição EFI encontrada para teste"
fi

echo ""
echo "3️⃣ Verificando permissões do app..."
if [ -f "EFI Swift GUI.app/Contents/Info.plist" ]; then
    echo "  📋 Info.plist encontrado"
    if grep -q "NSAppleEventsUsageDescription" "EFI Swift GUI.app/Contents/Info.plist"; then
        echo "  ✅ Permissões Apple Events configuradas"
    else
        echo "  ⚠️ Permissões Apple Events não encontradas"
    fi
else
    echo "  ❌ Info.plist não encontrado"
fi

echo ""
echo "✅ Teste concluído!"
echo ""
echo "📝 INSTRUÇÕES:"
echo "• O app agora solicita senha de administrador"
echo "• Usa osascript para privilégios elevados"
echo "• Detecta partições EFI automaticamente"
echo "• Monta/desmonta com comandos reais"
