import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header seguindo padrão macOS
            HStack(spacing: 12) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ajuda")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("EFI Mount Tool v\(AppConstants.version)")
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
                VStack(alignment: .leading, spacing: 20) {
                    // O que é EFI
                    HelpSection(
                        title: "O que é uma partição EFI?",
                        icon: "info.circle",
                        color: .blue
                    ) {
                        Text("A partição EFI (Extensible Firmware Interface) é uma partição especial que contém os arquivos de boot do sistema. É essencial para o funcionamento do macOS e outros sistemas operacionais modernos.")
                            .font(.body)
                    }
                    
                    // Como usar
                    HelpSection(
                        title: "Como usar este app?",
                        icon: "play.circle",
                        color: .green
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            HelpStep(number: 1, text: "Clique em 'Descobrir Partições' para buscar EFIs")
                            HelpStep(number: 2, text: "Selecione uma partição na lista")
                            HelpStep(number: 3, text: "Use 'Montar EFI' para acessar os arquivos")
                            HelpStep(number: 4, text: "Edite os arquivos necessários")
                            HelpStep(number: 5, text: "Use 'Desmontar EFI' quando terminar")
                        }
                    }
                    
                    // Funcionalidades
                    HelpSection(
                        title: "Funcionalidades",
                        icon: "star.circle",
                        color: .orange
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            FeatureItem(icon: "magnifyingglass", text: "Descoberta automática de partições EFI")
                            FeatureItem(icon: "lock.shield", text: "Montagem/desmontagem segura")
                            FeatureItem(icon: "folder", text: "Acesso direto aos arquivos EFI")
                            FeatureItem(icon: "swift", text: "Interface nativa do macOS")
                        }
                    }
                    
                    // Segurança
                    HelpSection(
                        title: "Avisos de Segurança",
                        icon: "exclamationmark.triangle",
                        color: .red
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            SecurityWarning(text: "Sempre faça backup antes de modificar arquivos EFI")
                            SecurityWarning(text: "Requer privilégios de administrador")
                            SecurityWarning(text: "Use com cuidado - alterações podem afetar o boot")
                            SecurityWarning(text: "Teste mudanças em ambiente seguro")
                        }
                    }
                    
                    // Comandos utilizados
                    HelpSection(
                        title: "Comandos Utilizados",
                        icon: "terminal",
                        color: .purple
                    ) {
                        VStack(alignment: .leading, spacing: 6) {
                            CommandItem(command: "diskutil list", description: "Lista todos os discos")
                            CommandItem(command: "diskutil mount", description: "Monta uma partição")
                            CommandItem(command: "diskutil unmount", description: "Desmonta uma partição")
                            CommandItem(command: "diskutil info", description: "Informações da partição")
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 600, height: 500)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

// MARK: - Help Section
struct HelpSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                content
            }
            .padding(12)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(NSColor.separatorColor), lineWidth: 0.5)
            )
        }
    }
}

// MARK: - Help Step
struct HelpStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(number)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 18, height: 18)
                .background(Color.accentColor)
                .clipShape(Circle())
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Feature Item
struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 16)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Security Warning
struct SecurityWarning: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .frame(width: 16)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Command Item (Reutilizado, mas melhorado)
struct CommandItem: View {
    let command: String
    let description: String
    
    var body: some View {
        HStack(spacing: 10) {
            Text(command)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(4)
            
            Text("—")
                .foregroundColor(.secondary)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    HelpView()
}
