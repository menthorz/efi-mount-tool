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
    
    // MARK: - Discover EFI Partitions
    func discoverPartitions() async {
        isLoading = true
        lastMessage = "Discovering EFI partitions..."
        
        do {
            let result = await executeScript(operation: .discover)
            switch result {
            case .success(let output):
                parsePartitions(from: output)
                lastMessage = "Partitions discovered successfully"
            case .failure(let error):
                lastMessage = "Error discovering partitions: \(error)"
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Mount Partition
    func mountPartition(at index: Int) async -> Bool {
        guard index >= 0 && index < partitions.count else { return false }
        
        isLoading = true
        let partition = partitions[index]
        lastMessage = "Mounting partition \(partition.deviceName)..."
        
        // Request administrator privileges
        let authorized = await requestAdminPrivileges()
        guard authorized else {
            lastMessage = "Administrator privileges required"
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
                lastMessage = "Partition mounted successfully"
                isLoading = false
                return true
            } else {
                lastMessage = "Mount error: \(output)"
                isLoading = false
                return false
            }
        case .failure(let error):
            lastMessage = "Mount error: \(error)"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Unmount Partition
    func unmountPartition(at index: Int) async -> Bool {
        guard index >= 0 && index < partitions.count else { return false }
        
        isLoading = true
        let partition = partitions[index]
        lastMessage = "Unmounting partition \(partition.deviceName)..."
        
        let result = await executeScript(operation: .unmount(partition.devicePath))
        
        switch result {
        case .success(let output):
            if output.contains("unmounted") || output.contains("desmontada") || output.contains("ejected") || output.contains("successfully") {
                partitions[index].mountPoint = "Not mounted"
                lastMessage = "Partition unmounted successfully"
                isLoading = false
                return true
            } else {
                lastMessage = "Unmount error: \(output)"
                isLoading = false
                return false
            }
        case .failure(let error):
            lastMessage = "Unmount error: \(error)"
            isLoading = false
            return false
        }
    }
    
    // MARK: - Request Administrator Privileges
    private func requestAdminPrivileges() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = "Administrator Privileges Required"
                alert.informativeText = "This app requires administrator privileges to mount/unmount EFI partitions. Your password will be requested."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Authorize")
                alert.addButton(withTitle: "Cancel")
                
                let response = alert.runModal()
                continuation.resume(returning: response == .alertFirstButtonReturn)
            }
        }
    }
    
    // MARK: - Open EFI in Finder
    func openEFIInFinder(partition: EFIPartition) {
        guard partition.isMounted else { return }
        
        let url = URL(fileURLWithPath: partition.mountPoint)
        NSWorkspace.shared.open(url)
    }
    
    // MARK: - Execute Script
    private func executeScript(operation: EFIOperation) async -> EFIOperationResult {
        return await withCheckedContinuation { continuation in
            let process = Process()
            let pipe = Pipe()
            
            process.standardOutput = pipe
            process.standardError = pipe
            process.executableURL = URL(fileURLWithPath: "/bin/bash")
            
            // Prepare command based on operation
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
                    continuation.resume(returning: .failure("Process terminated with code \(process.terminationStatus)"))
                }
            } catch {
                continuation.resume(returning: .failure(error.localizedDescription))
            }
        }
    }
    
    // MARK: - Build Command
    private func buildCommand(for operation: EFIOperation) -> String {
        switch operation {
        case .discover:
            // Search for EFI partitions more comprehensively
            return """
            # Search for EFI partitions in the system
            echo "Searching for EFI partitions..."
            
            # Search external drives that may have EFI
            for disk in $(diskutil list external | grep '^/dev/disk' | awk '{print $1}'); do
                info=$(diskutil info "$disk" 2>/dev/null)
                if echo "$info" | grep -qi "EFI\\|GUID_partition_scheme"; then
                    size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                    mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                    # Get disk name/model from parent disk
                    parent_disk=$(echo "$disk" | sed 's/s[0-9]*$//')
                    disk_name=$(diskutil info "$parent_disk" 2>/dev/null | grep "Device / Media Name" | awk -F: '{print $2}' | xargs)
                    if [ -z "$disk_name" ]; then
                        disk_name=$(diskutil info "$parent_disk" 2>/dev/null | grep "Media Name" | awk -F: '{print $2}' | xargs)
                    fi
                    if [ -z "$disk_name" ]; then
                        disk_name="Unknown Disk"
                    fi
                    if [ -z "$mount" ] || [ "$mount" = "Not applicable" ]; then
                        mount="Not mounted"
                    fi
                    echo "$disk|$size|$mount|$disk_name"
                fi
            done
            
            # Check internal partitions as well
            for disk_num in $(seq 0 9); do
                for part_num in $(seq 1 9); do
                    disk="/dev/disk${disk_num}s${part_num}"
                    info=$(diskutil info "$disk" 2>/dev/null)
                    if echo "$info" | grep -qi "EFI"; then
                        size=$(echo "$info" | grep "Disk Size" | awk -F: '{print $2}' | xargs)
                        mount=$(echo "$info" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                        # Get disk name/model from parent disk
                        parent_disk="/dev/disk${disk_num}"
                        disk_name=$(diskutil info "$parent_disk" 2>/dev/null | grep "Device / Media Name" | awk -F: '{print $2}' | xargs)
                        if [ -z "$disk_name" ]; then
                            disk_name=$(diskutil info "$parent_disk" 2>/dev/null | grep "Media Name" | awk -F: '{print $2}' | xargs)
                        fi
                        if [ -z "$disk_name" ]; then
                            disk_name="Internal Disk"
                        fi
                        if [ -z "$mount" ] || [ "$mount" = "Not applicable" ]; then
                            mount="Not mounted"
                        fi
                        echo "$disk|$size|$mount|$disk_name"
                    fi
                done
            done
            """
        case .mount(let devicePath):
            // Mount using diskutil with sudo and osascript to request password
            return """
            echo "Mounting \(devicePath)..."
            
            # Check if device exists
            if ! diskutil info "\(devicePath)" >/dev/null 2>&1; then
                echo "Error: Device \(devicePath) not found"
                exit 1
            fi
            
            # Try to mount with administrator privileges
            result=$(osascript -e 'do shell script "diskutil mount \(devicePath)" with administrator privileges' 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "EFI partition mounted successfully!"
                echo "$result"
                # Check where it was mounted
                mount_info=$(diskutil info "\(devicePath)" | grep "Mount Point" | awk -F: '{print $2}' | xargs)
                if [ ! -z "$mount_info" ] && [ "$mount_info" != "Not applicable" ]; then
                    echo "Location: $mount_info"
                else
                    echo "Location: /Volumes/EFI"
                fi
            else
                echo "Mount error: $result"
                exit 1
            fi
            """
        case .unmount(let devicePath):
            // Unmount trying first without sudo, then with sudo if necessary
            return """
            echo "Unmounting \(devicePath)..."
            
            # Check if device is mounted
            mount_info=$(diskutil info "\(devicePath)" 2>/dev/null | grep "Mount Point" | awk -F: '{print $2}' | xargs)
            if [ -z "$mount_info" ] || [ "$mount_info" = "Not applicable" ]; then
                echo "Device \(devicePath) is not mounted or already unmounted"
                echo "successfully unmounted"
                exit 0
            fi
            
            echo "Attempting unmount without administrative privileges..."
            
            # First attempt: simple unmount without sudo
            result=$(diskutil unmount "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "EFI partition unmounted successfully!"
                echo "successfully unmounted"
                echo "$result"
                exit 0
            fi
            
            echo "Simple unmount failed, trying forced unmount..."
            
            # Second attempt: forced unmount
            result=$(diskutil unmount force "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "EFI partition unmounted successfully (forced)!"
                echo "successfully unmounted"
                echo "$result"
                exit 0
            fi
            
            # If still fails, try eject
            echo "Trying to eject device..."
            result=$(diskutil eject "\(devicePath)" 2>&1)
            exit_code=$?
            
            if [ $exit_code -eq 0 ]; then
                echo "Device ejected successfully!"
                echo "successfully ejected"
                echo "$result"
                exit 0
            fi
            
            echo "All unmount attempts failed: $result"
            exit 1
            """
        case .systemInfo:
            return """
            echo "System: $(sw_vers -productName) $(sw_vers -productVersion)"
            echo "Build: $(sw_vers -buildVersion)"
            echo "Kernel: $(uname -r)"
            echo "Architecture: $(uname -m)"
            echo "User: $(whoami)"
            diskutil list | head -20
            """
        }
    }
    
    // MARK: - Parse Partitions
    private func parsePartitions(from output: String) {
        let lines = output.components(separatedBy: .newlines)
        var newPartitions: [EFIPartition] = []
        
        for line in lines {
            let components = line.components(separatedBy: "|")
            if components.count >= 4 {
                let devicePath = components[0].trimmingCharacters(in: .whitespaces)
                let size = components[1].trimmingCharacters(in: .whitespaces)
                let mountPoint = components[2].trimmingCharacters(in: .whitespaces)
                let diskName = components[3].trimmingCharacters(in: .whitespaces)
                
                let finalMountPoint = mountPoint.isEmpty || mountPoint == "Not applicable" ? "Not mounted" : mountPoint
                
                let partition = EFIPartition(
                    deviceName: devicePath,
                    devicePath: devicePath,
                    size: size.isEmpty ? "Unknown" : size,
                    diskName: diskName.isEmpty ? "Unknown Disk" : diskName,
                    mountPoint: finalMountPoint
                )
                newPartitions.append(partition)
            }
        }
        
        // If no real partitions found, create example partitions for demonstration
        if newPartitions.isEmpty {
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk0s1",
                devicePath: "/dev/disk0s1",
                size: "200.0 MB (209,715,200 bytes)",
                diskName: "APPLE SSD AP0256M",
                mountPoint: "Not mounted"
            ))
            
            newPartitions.append(EFIPartition(
                deviceName: "/dev/disk1s1",
                devicePath: "/dev/disk1s1",
                size: "300.0 MB (314,572,800 bytes)",
                diskName: "Samsung SSD 980 PRO",
                mountPoint: "Not mounted"
            ))
            
            // Add note for user
            lastMessage = "Example partitions created. Connect an external drive with EFI partition to use real features."
        } else {
            lastMessage = "Found \(newPartitions.count) EFI partition(s) in the system."
        }
        
        partitions = newPartitions
    }
    
    // MARK: - Extract Mount Point
    private func extractMountPoint(from output: String) -> String? {
        // Look for "/Volumes/EFI" pattern or similar in output
        let lines = output.components(separatedBy: .newlines)
        for line in lines {
            if line.contains("/Volumes/") {
                if let range = line.range(of: "/Volumes/[^\\s]+", options: .regularExpression) {
                    return String(line[range])
                }
            }
        }
        return "/Volumes/EFI" // Default
    }
    
    // MARK: - Update System Information
    func updateSystemInfo() async {
        isLoading = true
        lastMessage = "Updating system information..."
        
        let result = await executeScript(operation: .systemInfo)
        var diskCount = 0
        
        switch result {
        case .success(let output):
            // Parse output to count disks
            let lines = output.components(separatedBy: .newlines)
            for line in lines {
                if line.contains("/dev/disk") && !line.contains("s") { // Count only main disks, not partitions
                    diskCount += 1
                }
            }
            
            // Create new SystemInfo with updated information
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            
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
            
            lastMessage = "System information updated - \(diskCount) disk(s) detected"
        case .failure(let error):
            lastMessage = "Error getting information: \(error)"
        }
        
        isLoading = false
    }
}
