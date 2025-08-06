import Foundation

struct EFIPartition: Identifiable {
    let id = UUID()
    let deviceName: String
    let devicePath: String
    let size: String
    var mountPoint: String
    var isMounted: Bool {
        mountPoint != "Não montada" && !mountPoint.isEmpty
    }
    
    init(deviceName: String, devicePath: String, size: String, mountPoint: String) {
        self.deviceName = deviceName
        self.devicePath = devicePath
        self.size = size
        self.mountPoint = mountPoint
    }
}

struct SystemInfo {
    let date: String
    let user: String
    let system: String
    let kernel: String
    let architecture: String
    let totalDisks: Int
    let machineModel: String
    let cpuBrand: String
    let memorySize: String
    
    static func current() -> SystemInfo {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return SystemInfo(
            date: formatter.string(from: Date()),
            user: NSUserName(),
            system: getSystemVersion(),
            kernel: getKernelVersion(),
            architecture: getRealArchitecture(),
            totalDisks: 0, // Será atualizado pelo serviço
            machineModel: getMachineModel(),
            cpuBrand: getCPUBrand(),
            memorySize: getMemorySize()
        )
    }
    
    // MARK: - Métodos auxiliares para obter informações reais do sistema
    
    private static func getRealArchitecture() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? "Unknown"
            }
        }
        
        // Mapear para nomes mais amigáveis
        switch machine {
        case "arm64", "arm64e":
            return "Apple Silicon (ARM64)"
        case "x86_64":
            return "Intel (x86_64)"
        case let arch where arch.hasPrefix("i"):
            return "Intel (32-bit)"
        default:
            return machine
        }
    }
    
    private static func getSystemVersion() -> String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "macOS \(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
    
    private static func getKernelVersion() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let kernel = withUnsafePointer(to: &systemInfo.release) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? "Unknown"
            }
        }
        return "Darwin \(kernel)"
    }
    
    private static func getMachineModel() -> String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }
    
    private static func getCPUBrand() -> String {
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var brand = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &brand, &size, nil, 0)
        let brandString = String(cString: brand)
        
        // Se não conseguir obter via sysctl (comum em ARM), usar ProcessInfo
        if brandString.isEmpty {
            let cores = ProcessInfo.processInfo.processorCount
            var systemInfo = utsname()
            uname(&systemInfo)
            let machine = withUnsafePointer(to: &systemInfo.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    String(validatingUTF8: $0) ?? "Unknown"
                }
            }
            
            if machine.hasPrefix("arm64") {
                return "Apple Silicon (\(cores) cores)"
            } else {
                return "Processador Intel (\(cores) cores)"
            }
        }
        
        return brandString
    }
    
    private static func getMemorySize() -> String {
        var size = 0
        sysctlbyname("hw.memsize", nil, &size, nil, 0)
        var memsize: UInt64 = 0
        sysctlbyname("hw.memsize", &memsize, &size, nil, 0)
        
        let gb = Double(memsize) / 1_073_741_824
        return String(format: "%.1f GB", gb)
    }
}

enum EFIOperationResult {
    case success(String)
    case failure(String)
}

enum EFIOperation {
    case discover
    case mount(String)  // Agora aceita o path do dispositivo
    case unmount(String)  // Agora aceita o path do dispositivo
    case systemInfo
}
