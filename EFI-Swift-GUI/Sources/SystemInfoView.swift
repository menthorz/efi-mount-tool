import SwiftUI

struct SystemInfoView: View {
    let systemInfo: SystemInfo
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var efiService: EFIService
    
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
                    
                    Text("EFI Mount Tool v\(AppConstants.version)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Atualizar") {
                    Task {
                        await efiService.updateSystemInfo()
                    }
                }
                .help("Atualizar informações do sistema")
                .disabled(efiService.isLoading)
                
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
                    // Mostrar indicador de carregamento se estiver atualizando
                    if efiService.isLoading {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Atualizando informações do sistema...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    // Sistema
                    SystemInfoSection(title: "Sistema") {
                        SystemInfoRow(label: "Sistema Operacional", value: efiService.systemInfo.system)
                        SystemInfoRow(label: "Arquitetura", value: efiService.systemInfo.architecture)
                        SystemInfoRow(label: "Kernel", value: efiService.systemInfo.kernel)
                        SystemInfoRow(label: "Modelo da Máquina", value: efiService.systemInfo.machineModel)
                    }
                    
                    // Hardware
                    SystemInfoSection(title: "Hardware") {
                        SystemInfoRow(label: "Processador", value: efiService.systemInfo.cpuBrand)
                        SystemInfoRow(label: "Memória", value: efiService.systemInfo.memorySize)
                        SystemInfoRow(label: "Discos Conectados", value: "\(efiService.systemInfo.totalDisks) dispositivo(s)")
                    }
                    
                    // Usuário
                    SystemInfoSection(title: "Usuário") {
                        SystemInfoRow(label: "Nome do Usuário", value: efiService.systemInfo.user)
                        SystemInfoRow(label: "Diretório Home", value: NSHomeDirectory())
                        SystemInfoRow(label: "Data/Hora", value: efiService.systemInfo.date)
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
    SystemInfoView(systemInfo: SystemInfo.current(), efiService: EFIService())
}
