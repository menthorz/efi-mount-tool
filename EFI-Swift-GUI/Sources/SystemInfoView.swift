import SwiftUI

struct SystemInfoView: View {
    let systemInfo: SystemInfo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header mais compacto seguindo padrão macOS
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Informações do Sistema")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("EFI Mount Tool")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Fechar") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Sistema
                    SystemInfoSection(title: "Sistema") {
                        SystemInfoRow(label: "Sistema Operacional", value: systemInfo.system)
                        SystemInfoRow(label: "Arquitetura", value: systemInfo.architecture)
                        SystemInfoRow(label: "Kernel", value: systemInfo.kernel)
                    }
                    
                    // Usuário
                    SystemInfoSection(title: "Usuário") {
                        SystemInfoRow(label: "Nome do Usuário", value: systemInfo.user)
                        SystemInfoRow(label: "Diretório Home", value: NSHomeDirectory())
                        SystemInfoRow(label: "Data/Hora", value: systemInfo.date)
                    }
                    
                    // Hardware
                    SystemInfoSection(title: "Hardware") {
                        SystemInfoRow(label: "Processador", value: getProcessorInfo())
                        SystemInfoRow(label: "Memória", value: getMemoryInfo())
                        SystemInfoRow(label: "Discos Conectados", value: "\(systemInfo.totalDisks) dispositivos")
                    }
                    
                    // Comandos úteis
                    SystemInfoSection(title: "Comandos Úteis") {
                        VStack(spacing: 8) {
                            CommandRow(command: "diskutil list", description: "Listar todos os discos")
                            CommandRow(command: "system_profiler SPHardwareDataType", description: "Informações do hardware")
                            CommandRow(command: "sw_vers", description: "Versão do sistema")
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 580, height: 480)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    private func getProcessorInfo() -> String {
        return ProcessInfo.processInfo.processorCount > 1 
            ? "\(ProcessInfo.processInfo.processorCount) cores"
            : "Single core"
    }
    
    private func getMemoryInfo() -> String {
        let memory = ProcessInfo.processInfo.physicalMemory
        let gb = Double(memory) / 1_073_741_824 // Convert to GB
        return String(format: "%.1f GB", gb)
    }
}

// MARK: - System Info Section
struct SystemInfoSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
            )
        }
    }
}

// MARK: - System Info Row
struct SystemInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
                .frame(width: 140, alignment: .leading)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .textSelection(.enabled)
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

// MARK: - Command Row
struct CommandRow: View {
    let command: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(command)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.primary)
                    .textSelection(.enabled)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Copiar") {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(command, forType: .string)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
    }
}

#Preview {
    SystemInfoView(systemInfo: SystemInfo.current())
}
