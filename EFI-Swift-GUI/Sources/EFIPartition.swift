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
    
    static func current() -> SystemInfo {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return SystemInfo(
            date: formatter.string(from: Date()),
            user: NSUserName(),
            system: ProcessInfo.processInfo.operatingSystemVersionString,
            kernel: "Darwin",
            architecture: "arm64",
            totalDisks: 0 // Será atualizado pelo serviço
        )
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
