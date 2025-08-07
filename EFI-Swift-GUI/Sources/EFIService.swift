import Foundation
import Combine
import AppKit

@MainActor
class EFIService: ObservableObject {
    @Published var partitions: [EFIPartition] = []
    @Published var isLoading = false
    @Published var lastMessage = ""
    @Published var systemInfo = SystemInfo.current()
    
    private let scriptPath: String
    
    init() {
        // Procurar o script no mesmo diretório ou no bundle
        if let bundlePath = Bundle.main.path(forResource: "efi_mount", ofType: "sh") {
            scriptPath = bundlePath
        } else {
            // Fallback para o script no diretório atual
            scriptPath = "./efi_mount.sh"
        }
    }
    
    // MARK: - Descobrir Partições EFI
    func discoverPartitions() async {
        isLoading = true
        lastMessage = "Descobrindo partições EFI..."
        
        do {
            let result = await executeScript(operation: .discover)
            switch result {
            case .success(let output):
                parsePartitions(from: output)
                lastMessage = "Partições descobertas com sucesso!"
            case .failure(let error):
                lastMessage = "Erro ao descobrir partições: \(error)"
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Montar Partição
    func mountPartition(at index: Int) async -> Bool {
        guard index >= 0 && index < partitions.count else { return false }
        
        isLoading = true
        let partition = partitions[index]
        lastMessage = "Montando partição \(partition.deviceName)..."
        
        // Pedir privilégios de administrador
        let authorized = await requestAdminPrivileges()
        guard authorized else {
            lastMessage = "Privilégios de administrador necessários"
            isLoading = false
            return false
        }
        
        let result = await executeScript(operation: .mount(partition.devicePath))
        
        switch result {
        case .success(let output):
            if output.contains("mounted") || output.contains("montada") {
                // Atualizar status da partição
                if let mountPoint = extractMountPoint(from: output) {
                    partitions[index].mountPoint = mountPoint
                } else {
                    partitions[index].mountPoint = "/Volumes/EFI"
                }
                lastMessage = "Partição montada com sucesso!"
                isLoading = false
                return true
            } else {
                lastMessage = "Erro na montagem: \(output)"
                isLoading = false
                return false
            }
        case .failure(let error):
            lastMessage = "Erro ao montar: \(error)"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Desmontar Partição
    func unmountPartition(at index: Int) async -> Bool {
        guard index >= 0 && index < partitions.count else { return false }
        
        isLoading = true
        let partition = partitions[index]
        lastMessage = "Desmontando partição \(partition.deviceName)..."
        
        let result = await executeScript(operation: .unmount(partition.devicePath))
        
        switch result {
        case .success(let output):
            if output.contains("unmounted") || output.contains("desmontada") || output.contains("ejected") || output.contains("successfully") {
                partitions[index].mountPoint = "Não montada"
                lastMessage = "Partição desmontada com sucesso!"
                isLoading = false
                return true
            } else {
                lastMessage = "Erro na desmontagem: \(output)"
                isLoading = false
                return false
            }
        case .failure(let error):
            lastMessage = "Erro ao desmontar: \(error)"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Solicitar Privilégios de Administrador
    private func requestAdminPrivileges() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Privilégios de Administrador Necessários"
                alert.informativeText = "Este app precisa de privilégios de administrador para montar/desmontar partições EFI. Sua senha será solicitada."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Autorizar")
                alert.addButton(withTitle: "Cancelar")
                
                let response = alert.runModal()
                continuation.resume(returning: response == .alertFirstButtonReturn)
            }
        }
    }
    
    // MARK: - Abrir EFI no Finder
    func openEFIInFinder(partition: EFIPartition) {
        guard partition.isMounted else { return }
        
        let url = URL(fileURLWithPath: partition.mountPoint)
        NSWorkspace.shared.open(url)
    }
    
    // MARK: - Executar Script
    private func executeScript(operation: EFIOperation) async -> EFIOperationResult {
        return await withCheckedContinuation { continuation in
            let process = Process()
            let pipe = Pipe()
            
            process.standardOutput = pipe
            process.standardError = pipe
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            
            // Preparar comando baseado na operação
            let command = buildCommand(for: operation)
            process.arguments = ["-c", command]
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""
                
                if process.terminationStatus == 0 {
                    continuation.resume(returning: .success(output))
                } else {
                    continuation.resume(returning: .failure("Processo terminou com código \(process.terminationStatus)"))
                }
            } catch {
                continuation.resume(returning: .failure(error.localizedDescription))
            }
        }
    }
    
    // MARK: - Construir Comando
    private func buildCommand(for operation: EFIOperation) -> String {
        switch operation {
        case .discover:
            // Buscar partições EFI de forma mais abrangente
            return """
            # Buscar partições EFI no sistema
            echo "Buscando partições EFI..."
            
            # Buscar drives externos que podem ter EFI
            for disk in $(diskutil list external | grep '^/dev/disk' | awk '{print $1}'); do
                info=$(diskutil info "$disk" 2>/dev/null)
                if echo "$info" | grep -qi "EFI\\|GUID_partition_scheme"; then
                    size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                    mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                    if [ -z "$mount" ] || [ "$mount" = "Not applicable" ]; then
                        mount="Não montada"
                    fi
                    echo "$disk|$size|$mount"
                fi
            done
            
            # Verificar partições internas também
            for disk_num in $(seq 0 9); do
                for part_num in $(seq 1 9); do
                    disk="/dev/disk${disk_num}s${part_num}"
                    info=$(diskutil info "$disk" 2>/dev/null)
                    if echo "$info" | grep -qi "EFI"; then
                        size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                        mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                        if [ -z "$mount" ] || [ "$mount" = "Not applicable" ]; then
                            mount="Não montada"
                        fi
                        echo "$disk|$size|$mount"
                    fi
                done
            done
            """
        case .mount(let devicePath):
            // Montar usando diskutil com sudo e osascript para pedir senha
            return """
            echo "Montando \(devicePath)..."
            
            # Verificar se o dispositivo existe
            if ! diskutil info "\(devicePath)" >/dev/null 2>&1; then
                echo "Erro: Dispositivo \(devicePath) não encontrado"
                exit 1
            fi
            
            # Tentar montar com privilégios de administrador
            result=$(osascript -e 'do shell script "diskutil mount \(devicePath)" with administrator privileges' 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "Partição EFI montada com sucesso!"
                echo "$result"
                # Verificar onde foi montada
                mount_info=$(diskutil info "\(devicePath)" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                if [ ! -z "$mount_info" ] && [ "$mount_info" != "Not applicable" ]; then
                    echo "Localização: $mount_info"
                else
                    echo "Localização: /Volumes/EFI"
                fi
            else
                echo "Erro na montagem: $result"
                exit 1
            fi
            """
        case .unmount(let devicePath):
            // Desmontar tentando primeiro sem sudo, depois com sudo se necessário
            return """
            echo "Desmontando \(devicePath)..."
            
            # Verificar se o dispositivo está montado
            mount_info=$(diskutil info "\(devicePath)" 2>/dev/null | grep "Mount Point" | awk -F: '{print $2}' | xargs)
            if [ -z "$mount_info" ] || [ "$mount_info" = "Not applicable" ]; then
                echo "Dispositivo \(devicePath) não está montado ou já foi desmontado"
                echo "successfully unmounted"
                exit 0
            fi
            
            echo "Tentando desmontagem sem privilégios administrativos..."
            
            # Primeira tentativa: desmontagem simples sem sudo
            result=$(diskutil unmount "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "Partição EFI desmontada com sucesso!"
                echo "successfully unmounted"
                echo "$result"
                exit 0
            fi
            
            echo "Desmontagem simples falhou, tentando desmontagem forçada..."
            
            # Segunda tentativa: desmontagem forçada
            result=$(diskutil unmount force "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "Partição EFI desmontada com sucesso (forçada)!"
                echo "successfully unmounted"
                echo "$result"
                exit 0
            fi
            
            # Se ainda falhar, tentar eject
            echo "Tentando ejetar dispositivo..."
            result=$(diskutil eject "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "Dispositivo ejetado com sucesso!"
                echo "successfully ejected"
                echo "$result"
                exit 0
            fi
            
            echo "Todas as tentativas de desmontagem falharam: $result"
            exit 1
            """
        case .systemInfo:
            return """
            echo "Sistema: $(sw_vers -productName) $(sw_vers -productVersion)"
            echo "Build: $(sw_vers -buildVersion)"
            echo "Kernel: $(uname -r)"
            echo "Arquitetura: $(uname -m)"
            echo "Usuário: $(whoami)"
            diskutil list | head -20
            """
        }
    }
    
    // MARK: - Parse das Partições
    private func parsePartitions(from output: String) {
        let lines = output.components(separatedBy: .newlines)
        var newPartitions: [EFIPartition] = []
        
        for line in lines {
            let components = line.components(separatedBy: "|")
            if components.count >= 3 {
                let devicePath = components[0].trimmingCharacters(in: .whitespaces)
                let size = components[1].trimmingCharacters(in: .whitespaces)
                let mountPoint = components[2].trimmingCharacters(in: .whitespaces)
                
                let finalMountPoint = mountPoint.isEmpty || mountPoint == "Not applicable" ? "Não montada" : mountPoint
                
                let partition = EFIPartition(
                    deviceName: devicePath,
                    devicePath: devicePath,
                    size: size.isEmpty ? "Unknown" : size,
                    mountPoint: finalMountPoint
                )
                newPartitions.append(partition)
            }
        }
        
        // Se não encontrou partições reais, criar partições de exemplo para demonstração
        if newPartitions.isEmpty {
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk0s1",
                devicePath: "/dev/disk0s1",
                size: "200.0 MB (209,715,200 bytes)",
                mountPoint: "Não montada"
            ))
            
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk1s1",
                devicePath: "/dev/disk1s1",
                size: "300.0 MB (314,572,800 bytes)",
                mountPoint: "Não montada"
            ))
            
            // Adicionar nota para o usuário
            lastMessage = "Partições de exemplo criadas. Conecte um drive externo com partição EFI para usar recursos reais."
        } else {
            lastMessage = "Encontradas \(newPartitions.count) partição(ões) EFI no sistema."
        }
        
        partitions = newPartitions
    }
    
    // MARK: - Extrair Mount Point
    private func extractMountPoint(from output: String) -> String? {
        // Procurar por padrão "/Volumes/EFI" ou similar no output
        let lines = output.components(separatedBy: .newlines)
        for line in lines {
            if line.contains("/Volumes/") {
                if let range = line.range(of: "/Volumes/[^\\s]+", options: .regularExpression) {
                    return String(line[range])
                }
            }
        }
        return "/Volumes/EFI" // Padrão
    }
    
    // MARK: - Atualizar Informações do Sistema
    func updateSystemInfo() async {
        isLoading = true
        lastMessage = "Atualizando informações do sistema..."
        
        let result = await executeScript(operation: .systemInfo)
        var diskCount = 0
        
        switch result {
        case .success(let output):
            // Parse do output para contar discos
            let lines = output.components(separatedBy: .newlines)
            for line in lines {
                if line.contains("/dev/disk") && !line.contains("s") { // Conta apenas discos principais, não partições
                    diskCount += 1
                }
            }
            
            // Criar novo SystemInfo com informações atualizadas
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            
            systemInfo = SystemInfo(
                date: formatter.string(from: Date()),
                user: systemInfo.user,
                system: systemInfo.system,
                kernel: systemInfo.kernel,
                architecture: systemInfo.architecture,
                totalDisks: diskCount,
                machineModel: systemInfo.machineModel,
                cpuBrand: systemInfo.cpuBrand,
                memorySize: systemInfo.memorySize
            )
            
            lastMessage = "Informações do sistema atualizadas - \(diskCount) disco(s) detectado(s)"
        case .failure(let error):
            lastMessage = "Erro ao obter informações: \(error)"
        }
        
        isLoading = false
    }
}
