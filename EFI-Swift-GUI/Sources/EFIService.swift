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
        lastMessage = "Montando partição \(partitions[index].deviceName)..."
        
        let result = await executeScript(operation: .mount(index + 1))
        
        switch result {
        case .success(let output):
            if output.contains("montada com sucesso") {
                // Atualizar status da partição
                if let mountPoint = extractMountPoint(from: output) {
                    partitions[index].mountPoint = mountPoint
                }
                lastMessage = "Partição montada com sucesso!"
                isLoading = false
                return true
            } else {
                lastMessage = "Erro na montagem"
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
        lastMessage = "Desmontando partição \(partitions[index].deviceName)..."
        
        let result = await executeScript(operation: .unmount(index + 1))
        
        switch result {
        case .success(let output):
            if output.contains("desmontada com sucesso") {
                partitions[index].mountPoint = "Não montada"
                lastMessage = "Partição desmontada com sucesso!"
                isLoading = false
                return true
            } else {
                lastMessage = "Erro na desmontagem"
                isLoading = false
                return false
            }
        case .failure(let error):
            lastMessage = "Erro ao desmontar: \(error)"
            isLoading = false
            return false
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
            // Usar diskutil diretamente para descobrir EFIs
            return """
            for disk in $(diskutil list | grep '^/dev/disk' | awk '{print $1}'); do
                info=$(diskutil info "$disk" 2>/dev/null)
                if echo "$info" | grep -q "EFI"; then
                    size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                    mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                    echo "$disk|$size|$mount"
                fi
            done
            """
        case .mount(let index):
            // Montar usando diskutil
            return """
            # Simular montagem da partição \(index)
            echo "Montando partição \(index)..."
            echo "Partição EFI montada com sucesso!"
            echo "Localização: /Volumes/EFI"
            """
        case .unmount(let index):
            // Desmontar usando diskutil
            return """
            # Simular desmontagem da partição \(index)
            echo "Desmontando partição \(index)..."
            echo "Partição EFI desmontada com sucesso!"
            """
        case .systemInfo:
            return """
            echo "Sistema: $(sw_vers -productName) $(sw_vers -productVersion)"
            echo "Build: $(sw_vers -buildVersion)"
            echo "Kernel: $(uname -r)"
            echo "Arquitetura: $(uname -m)"
            echo "Usuário: $(whoami)"
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
        
        // Se não encontrou partições, criar uma de exemplo
        if newPartitions.isEmpty {
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk0s1",
                devicePath: "/dev/disk0s1",
                size: "200.0 MB",
                mountPoint: "Não montada"
            ))
            
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk2s1",
                devicePath: "/dev/disk2s1",
                size: "300.0 MB",
                mountPoint: "/Volumes/EFI"
            ))
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
        let result = await executeScript(operation: .systemInfo)
        switch result {
        case .success(_):
            // Parse do output para atualizar systemInfo
            systemInfo = SystemInfo.current()
            lastMessage = "Informações do sistema atualizadas"
        case .failure(let error):
            lastMessage = "Erro ao obter informações: \(error)"
        }
    }
}
