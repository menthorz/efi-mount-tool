import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var efiService: EFIService
    @State private var selectedPartition: EFIPartition?
    @State private var showingSystemInfo = false
    @State private var showingHelp = false
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            VStack(alignment: .leading, spacing: 16) {
                headerSection
                partitionsSection
                actionsSection
                Spacer()
                statusSection
            }
            .padding()
            .frame(minWidth: 300)
        } detail: {
            // Detail View
            if let partition = selectedPartition {
                PartitionDetailView(partition: partition, service: efiService)
            } else {
                welcomeView
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Ajuda") {
                    showingHelp = true
                }
                .help("Mostrar ajuda sobre o EFI Mount Tool")
                
                Button("Sistema") {
                    showingSystemInfo = true
                }
                .help("Informações do sistema")
                
                Button("Atualizar") {
                    Task {
                        await efiService.discoverPartitions()
                    }
                }
                .help("Atualizar lista de partições")
                .disabled(efiService.isLoading)
            }
        }
        .sheet(isPresented: $showingSystemInfo) {
            SystemInfoView(systemInfo: efiService.systemInfo, efiService: efiService)
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
        .task {
            await efiService.discoverPartitions()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "externaldrive.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("EFI Mount Tool")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Text("Interface Swift para gerenciar partições EFI")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Partitions Section
    private var partitionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Partições EFI")
                    .font(.headline)
                Spacer()
                if efiService.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            if efiService.partitions.isEmpty && !efiService.isLoading {
                Text("Nenhuma partição EFI encontrada")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(efiService.partitions) { partition in
                            PartitionRowView(
                                partition: partition,
                                isSelected: selectedPartition?.id == partition.id
                            )
                            .onTapGesture {
                                selectedPartition = partition
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 300) // Limita altura máxima para forçar scroll quando necessário
            }
        }
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ações")
                .font(.headline)
            
            Button("Descobrir Partições") {
                Task {
                    await efiService.discoverPartitions()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(efiService.isLoading)
            
            if let partition = selectedPartition {
                if partition.isMounted {
                    Button("Desmontar EFI") {
                        Task {
                            if let index = efiService.partitions.firstIndex(where: { $0.id == partition.id }) {
                                _ = await efiService.unmountPartition(at: index)
                                selectedPartition = efiService.partitions[index]
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(efiService.isLoading)
                    
                    Button("Abrir no Finder") {
                        efiService.openEFIInFinder(partition: partition)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Button("Montar EFI") {
                        Task {
                            if let index = efiService.partitions.firstIndex(where: { $0.id == partition.id }) {
                                _ = await efiService.mountPartition(at: index)
                                selectedPartition = efiService.partitions[index]
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(efiService.isLoading)
                }
            }
        }
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Status")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(efiService.lastMessage)
                .font(.caption)
                .foregroundColor(efiService.isLoading ? .blue : .primary)
                .lineLimit(3)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
    
    // MARK: - Welcome View
    private var welcomeView: some View {
        VStack(spacing: 20) {
            Image(systemName: "externaldrive.fill.badge.gearshape")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("EFI Mount Tool")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Selecione uma partição EFI na lista à esquerda para começar")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 8) {
                Label("Descubra partições EFI automaticamente", systemImage: "magnifyingglass")
                Label("Monte e desmonte com segurança", systemImage: "lock.shield")
                Label("Acesse arquivos EFI diretamente", systemImage: "folder")
                Label("Interface nativa do macOS", systemImage: "swift")
            }
            .font(.body)
            .foregroundColor(.secondary)
        }
        .padding(40)
    }
}

// MARK: - Partition Row View
struct PartitionRowView: View {
    let partition: EFIPartition
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(partition.deviceName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(partition.size)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .fill(partition.isMounted ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    
                    Text(partition.isMounted ? "Montada" : "Não montada")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if partition.isMounted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(12)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(EFIService())
        .frame(width: 1000, height: 700)
}
