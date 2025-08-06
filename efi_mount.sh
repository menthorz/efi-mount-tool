#!/bin/bash

# EFI Mount - Shell Script App
# Versão 1.0 - Interface amigável para montagem de partições EFI

# Cores para interface
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Símbolos
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
WARNING="⚠️"
DISK="💾"
MOUNT="🔗"
UNMOUNT="🔓"
FOLDER="📁"

# Função para limpar a tela
clear_screen() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                     ${WHITE}EFI MOUNT TOOL${BLUE}                          ║${NC}"
    echo -e "${BLUE}║               ${CYAN}Shell Script Interface v1.0${BLUE}                ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Função para mostrar header com status
show_header() {
    clear_screen
    echo -e "${PURPLE}${DISK} Status do Sistema:${NC}"
    echo -e "   • Data/Hora: ${CYAN}$(date '+%d/%m/%Y %H:%M:%S')${NC}"
    echo -e "   • Usuário: ${CYAN}$(whoami)${NC}"
    echo -e "   • Sistema: ${CYAN}$(sw_vers -productName) $(sw_vers -productVersion)${NC}"
    echo ""
}

# Função para descobrir partições EFI
discover_efi_partitions() {
    echo -e "${YELLOW}${INFO} Descobrindo partições EFI...${NC}"
    echo ""
    
    # Obter lista de discos
    local disks=$(diskutil list | grep '^/dev/disk' | awk '{print $1}')
    local efi_found=false
    local counter=1
    
    # Array para armazenar informações das partições EFI
    declare -g -a EFI_DISKS=()
    declare -g -a EFI_PARTITIONS=()
    declare -g -a EFI_SIZES=()
    declare -g -a EFI_MOUNT_POINTS=()
    
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    ${WHITE}PARTIÇÕES EFI ENCONTRADAS${BLUE}                ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
    
    for disk in $disks; do
        # Obter informações do disco
        local disk_info=$(diskutil info "$disk" 2>/dev/null)
        
        if [[ $? -eq 0 ]]; then
            # Verificar se é uma partição EFI
            if echo "$disk_info" | grep -q "EFI"; then
                efi_found=true
                
                # Extrair informações
                local size=$(echo "$disk_info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                local mount_point=$(echo "$disk_info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                local device_name=$(echo "$disk_info" | grep "Device Node" | awk -F: '{print $2}' | xargs)
                
                # Se não tiver mount point, mostrar como "Não montada"
                if [[ -z "$mount_point" ]]; then
                    mount_point="Não montada"
                fi
                
                # Adicionar aos arrays
                EFI_DISKS+=("$device_name")
                EFI_PARTITIONS+=("$disk")
                EFI_SIZES+=("$size")
                EFI_MOUNT_POINTS+=("$mount_point")
                
                # Mostrar informações formatadas
                echo -e "${BLUE}║${NC} ${WHITE}[$counter]${NC} ${GREEN}$device_name${NC}"
                echo -e "${BLUE}║${NC}     ${CYAN}Tamanho:${NC} $size"
                echo -e "${BLUE}║${NC}     ${CYAN}Status:${NC} $mount_point"
                echo -e "${BLUE}║${NC}"
                
                ((counter++))
            fi
        fi
    done
    
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [[ "$efi_found" == false ]]; then
        echo -e "${RED}${CROSS} Nenhuma partição EFI encontrada!${NC}"
        return 1
    else
        echo -e "${GREEN}${CHECK} Encontradas $((counter-1)) partições EFI${NC}"
        return 0
    fi
}

# Função para montar partição EFI
mount_efi_partition() {
    local partition_index=$1
    
    if [[ -z "$partition_index" ]] || [[ $partition_index -lt 1 ]] || [[ $partition_index -gt ${#EFI_PARTITIONS[@]} ]]; then
        echo -e "${RED}${CROSS} Índice de partição inválido!${NC}"
        return 1
    fi
    
    local array_index=$((partition_index - 1))
    local device="${EFI_PARTITIONS[$array_index]}"
    local device_name="${EFI_DISKS[$array_index]}"
    
    echo -e "${YELLOW}${MOUNT} Tentando montar $device_name...${NC}"
    echo ""
    
    # Verificar se já está montada
    if [[ "${EFI_MOUNT_POINTS[$array_index]}" != "Não montada" ]]; then
        echo -e "${YELLOW}${WARNING} A partição já está montada em: ${CYAN}${EFI_MOUNT_POINTS[$array_index]}${NC}"
        return 0
    fi
    
    # Tentar montar usando sudo
    echo -e "${INFO} ${YELLOW}Digite sua senha de administrador para montar a partição EFI:${NC}"
    if sudo diskutil mount "$device"; then
        echo ""
        echo -e "${GREEN}${CHECK} Partição EFI montada com sucesso!${NC}"
        
        # Obter o novo mount point
        local new_mount_point=$(diskutil info "$device" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
        EFI_MOUNT_POINTS[$array_index]="$new_mount_point"
        
        echo -e "${CYAN}${FOLDER} Localização: $new_mount_point${NC}"
        echo ""
        
        # Perguntar se quer abrir no Finder
        echo -e "${YELLOW}Deseja abrir a pasta EFI no Finder? (s/n):${NC} \c"
        read -r open_finder
        if [[ "$open_finder" =~ ^[SsYy]$ ]]; then
            open "$new_mount_point"
            echo -e "${GREEN}${CHECK} Pasta EFI aberta no Finder${NC}"
        fi
        
        return 0
    else
        echo ""
        echo -e "${RED}${CROSS} Erro ao montar a partição EFI!${NC}"
        return 1
    fi
}

# Função para desmontar partição EFI
unmount_efi_partition() {
    local partition_index=$1
    
    if [[ -z "$partition_index" ]] || [[ $partition_index -lt 1 ]] || [[ $partition_index -gt ${#EFI_PARTITIONS[@]} ]]; then
        echo -e "${RED}${CROSS} Índice de partição inválido!${NC}"
        return 1
    fi
    
    local array_index=$((partition_index - 1))
    local device="${EFI_PARTITIONS[$array_index]}"
    local device_name="${EFI_DISKS[$array_index]}"
    local mount_point="${EFI_MOUNT_POINTS[$array_index]}"
    
    echo -e "${YELLOW}${UNMOUNT} Tentando desmontar $device_name...${NC}"
    echo ""
    
    # Verificar se está montada
    if [[ "$mount_point" == "Não montada" ]]; then
        echo -e "${YELLOW}${WARNING} A partição já está desmontada!${NC}"
        return 0
    fi
    
    # Tentar desmontar usando sudo
    echo -e "${INFO} ${YELLOW}Digite sua senha de administrador para desmontar a partição EFI:${NC}"
    if sudo diskutil unmount "$device"; then
        echo ""
        echo -e "${GREEN}${CHECK} Partição EFI desmontada com sucesso!${NC}"
        EFI_MOUNT_POINTS[$array_index]="Não montada"
        return 0
    else
        echo ""
        echo -e "${RED}${CROSS} Erro ao desmontar a partição EFI!${NC}"
        return 1
    fi
}

# Função para mostrar informações detalhadas do sistema
show_system_info() {
    clear_screen
    echo -e "${PURPLE}${INFO} Informações Detalhadas do Sistema${NC}"
    echo ""
    
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    ${WHITE}INFORMAÇÕES DO SISTEMA${BLUE}                   ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
    
    # Sistema operacional
    echo -e "${BLUE}║${NC} ${CYAN}Sistema:${NC} $(sw_vers -productName) $(sw_vers -productVersion)"
    echo -e "${BLUE}║${NC} ${CYAN}Build:${NC} $(sw_vers -buildVersion)"
    echo -e "${BLUE}║${NC} ${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${BLUE}║${NC} ${CYAN}Arquitetura:${NC} $(uname -m)"
    echo -e "${BLUE}║${NC}"
    
    # Informações do usuário
    echo -e "${BLUE}║${NC} ${CYAN}Usuário:${NC} $(whoami)"
    echo -e "${BLUE}║${NC} ${CYAN}Home:${NC} $HOME"
    echo -e "${BLUE}║${NC} ${CYAN}Shell:${NC} $SHELL"
    echo -e "${BLUE}║${NC}"
    
    # Informações de disco
    echo -e "${BLUE}║${NC} ${CYAN}Discos Conectados:${NC}"
    local disk_count=$(diskutil list | grep '^/dev/disk' | wc -l | xargs)
    echo -e "${BLUE}║${NC}   • Total de discos: $disk_count"
    
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Mostrar todos os discos
    echo -e "${YELLOW}${DISK} Lista de Todos os Discos:${NC}"
    echo ""
    diskutil list
    echo ""
    
    echo -e "${CYAN}Pressione Enter para voltar ao menu...${NC}"
    read -r
}

# Função para mostrar ajuda
show_help() {
    clear_screen
    echo -e "${PURPLE}${INFO} Ajuda - EFI Mount Tool${NC}"
    echo ""
    
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                         ${WHITE}AJUDA${BLUE}                              ║${NC}"
    echo -e "${BLUE}╠══════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC} ${CYAN}O que é uma partição EFI?${NC}"
    echo -e "${BLUE}║${NC} A partição EFI (Extensible Firmware Interface) é uma"
    echo -e "${BLUE}║${NC} partição especial que contém os arquivos de boot do sistema."
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC} ${CYAN}Para que serve este app?${NC}"
    echo -e "${BLUE}║${NC} • Descobrir partições EFI no sistema"
    echo -e "${BLUE}║${NC} • Montar/desmontar partições EFI com segurança"
    echo -e "${BLUE}║${NC} • Acessar arquivos EFI para modificação"
    echo -e "${BLUE}║${NC} • Gerenciar bootloaders (OpenCore, Clover, etc.)"
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC} ${CYAN}Segurança:${NC}"
    echo -e "${BLUE}║${NC} • Sempre faça backup antes de modificar arquivos EFI"
    echo -e "${BLUE}║${NC} • Requer privilégios de administrador"
    echo -e "${BLUE}║${NC} • Use com cuidado - alterações podem afetar o boot"
    echo -e "${BLUE}║${NC}"
    echo -e "${BLUE}║${NC} ${CYAN}Comandos usados:${NC}"
    echo -e "${BLUE}║${NC} • diskutil list - Lista todos os discos"
    echo -e "${BLUE}║${NC} • diskutil mount - Monta uma partição"
    echo -e "${BLUE}║${NC} • diskutil unmount - Desmonta uma partição"
    echo -e "${BLUE}║${NC} • diskutil info - Mostra informações de uma partição"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}Pressione Enter para voltar ao menu...${NC}"
    read -r
}

# Menu principal
main_menu() {
    while true; do
        show_header
        
        echo -e "${WHITE}${DISK} Menu Principal:${NC}"
        echo ""
        echo -e "   ${GREEN}[1]${NC} ${CYAN}Descobrir Partições EFI${NC}"
        echo -e "   ${GREEN}[2]${NC} ${CYAN}Montar Partição EFI${NC}"
        echo -e "   ${GREEN}[3]${NC} ${CYAN}Desmontar Partição EFI${NC}"
        echo -e "   ${GREEN}[4]${NC} ${CYAN}Atualizar Lista${NC}"
        echo -e "   ${GREEN}[5]${NC} ${CYAN}Informações do Sistema${NC}"
        echo -e "   ${GREEN}[6]${NC} ${CYAN}Ajuda${NC}"
        echo -e "   ${RED}[0]${NC} ${CYAN}Sair${NC}"
        echo ""
        echo -e "${YELLOW}Escolha uma opção (0-6):${NC} \c"
        
        read -r choice
        echo ""
        
        case $choice in
            1)
                discover_efi_partitions
                if [[ $? -eq 0 ]]; then
                    echo ""
                    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                    read -r
                fi
                ;;
            2)
                if [[ ${#EFI_PARTITIONS[@]} -eq 0 ]]; then
                    echo -e "${RED}${CROSS} Primeiro descubra as partições EFI (opção 1)${NC}"
                    echo ""
                    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                    read -r
                else
                    echo -e "${YELLOW}Digite o número da partição para montar (1-${#EFI_PARTITIONS[@]}):${NC} \c"
                    read -r partition_num
                    mount_efi_partition "$partition_num"
                    echo ""
                    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                    read -r
                fi
                ;;
            3)
                if [[ ${#EFI_PARTITIONS[@]} -eq 0 ]]; then
                    echo -e "${RED}${CROSS} Primeiro descubra as partições EFI (opção 1)${NC}"
                    echo ""
                    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                    read -r
                else
                    echo -e "${YELLOW}Digite o número da partição para desmontar (1-${#EFI_PARTITIONS[@]}):${NC} \c"
                    read -r partition_num
                    unmount_efi_partition "$partition_num"
                    echo ""
                    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                    read -r
                fi
                ;;
            4)
                discover_efi_partitions
                echo ""
                echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                read -r
                ;;
            5)
                show_system_info
                ;;
            6)
                show_help
                ;;
            0)
                clear_screen
                echo -e "${GREEN}${CHECK} Obrigado por usar o EFI Mount Tool!${NC}"
                echo -e "${CYAN}Até logo! 👋${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}${CROSS} Opção inválida! Use números de 0 a 6.${NC}"
                echo ""
                echo -e "${CYAN}Pressione Enter para continuar...${NC}"
                read -r
                ;;
        esac
    done
}

# Verificar se está rodando no macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}${CROSS} Este script foi feito para macOS!${NC}"
    exit 1
fi

# Verificar se diskutil está disponível
if ! command -v diskutil &> /dev/null; then
    echo -e "${RED}${CROSS} comando 'diskutil' não encontrado!${NC}"
    exit 1
fi

# Função de inicialização
init_app() {
    clear_screen
    echo -e "${GREEN}${CHECK} Bem-vindo ao EFI Mount Tool!${NC}"
    echo -e "${CYAN}Uma ferramenta shell script para gerenciar partições EFI${NC}"
    echo ""
    echo -e "${YELLOW}${WARNING} ATENÇÃO:${NC}"
    echo -e "• Este app requer privilégios de administrador"
    echo -e "• Sempre faça backup antes de modificar arquivos EFI"
    echo -e "• Use com responsabilidade"
    echo ""
    echo -e "${CYAN}Pressione Enter para continuar...${NC}"
    read -r
}

# Inicializar e executar o app
init_app
main_menu
