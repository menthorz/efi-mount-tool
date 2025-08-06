import SwiftUI

struct PartitionDetailView: View {
    let partition: EFIPartition
    let service: EFIService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "externaldrive.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(partition.deviceName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Partição EFI")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                StatusBadge(isMounted: partition.isMounted)
            }
            
            Divider()
            
            // Information Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                InfoCard(title: "Dispositivo", value: partition.devicePath, icon: "externaldrive")
                InfoCard(title: "Tamanho", value: partition.size, icon: "scale.3d")
                InfoCard(title: "Status", value: partition.isMounted ? "Montada" : "Não montada", icon: "checkmark.circle")
                InfoCard(title: "Localização", value: partition.mountPoint, icon: "folder")
            }
            
            Divider()
            
            // Actions
            VStack(alignment: .leading, spacing: 12) {
                Text("Ações Disponíveis")
                    .font(.headline)
                
                if partition.isMounted {
                    ActionButton(
                        title: "Abrir no Finder",
                        subtitle: "Acessar arquivos EFI",
                        icon: "folder",
                        color: .blue
                    ) {
                        service.openEFIInFinder(partition: partition)
                    }
                    
                    ActionButton(
                        title: "Desmontar EFI",
                        subtitle: "Desmontar partição com segurança",
                        icon: "eject",
                        color: .orange
                    ) {
                        Task {
                            if let index = service.partitions.firstIndex(where: { $0.id == partition.id }) {
                                _ = await service.unmountPartition(at: index)
                            }
                        }
                    }
                } else {
                    ActionButton(
                        title: "Montar EFI",
                        subtitle: "Montar partição para acesso",
                        icon: "plus.circle",
                        color: .green
                    ) {
                        Task {
                            if let index = service.partitions.firstIndex(where: { $0.id == partition.id }) {
                                _ = await service.mountPartition(at: index)
                            }
                        }
                    }
                }
                
                // Warning
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Aviso de Segurança")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Text("Sempre faça backup antes de modificar arquivos EFI. Alterações incorretas podem afetar o boot do sistema.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(24)
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let isMounted: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isMounted ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
            
            Text(isMounted ? "Montada" : "Não montada")
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isMounted ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Info Card
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
            }
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PartitionDetailView(
        partition: EFIPartition(
            deviceName: "/dev/disk0s1",
            devicePath: "/dev/disk0s1",
            size: "200.0 MB",
            mountPoint: "/Volumes/EFI"
        ),
        service: EFIService()
    )
    .frame(width: 500, height: 600)
}
