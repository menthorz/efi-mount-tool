import SwiftUI
import AppKit
import Combine
import UserNotifications

@MainActor
class MenuBarManager: NSObject, ObservableObject {
    private var statusItem: NSStatusItem?
    private var efiService: EFIService
    private var cancellables = Set<AnyCancellable>()
    
    init(efiService: EFIService) {
        self.efiService = efiService
        super.init()
        setupMenuBar()
        observeEFIService()
    }
    
    deinit {
        statusItem?.statusBar?.removeStatusItem(statusItem!)
    }
    
    // MARK: - Setup Menu Bar
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let statusItem = statusItem else { return }
        
        // Ícone da system tray
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "externaldrive.fill", accessibilityDescription: "EFI Mount Tool")
            button.image?.size = NSSize(width: 18, height: 18)
            button.image?.isTemplate = true
            button.toolTip = "EFI Mount Tool"
        }
        
        updateMenu()
    }
    
    // MARK: - Observe EFI Service
    private func observeEFIService() {
        // Update menu when partitions change
        efiService.$partitions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenu()
            }
            .store(in: &cancellables)
        
        // Update menu when loading status changes
        efiService.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateMenu()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Update Menu
    private func updateMenu() {
        guard let statusItem = statusItem else { return }
        
        let menu = NSMenu()
        
        // Header com título
        let titleItem = NSMenuItem()
        titleItem.attributedTitle = NSAttributedString(
            string: "EFI Mount Tool v\(AppConstants.version)",
            attributes: [
                .font: NSFont.menuBarFont(ofSize: 13).withTraits(.bold),
                .foregroundColor: NSColor.labelColor
            ]
        )
        titleItem.isEnabled = false
        menu.addItem(titleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Status de loading
        if efiService.isLoading {
            let loadingItem = NSMenuItem(title: "⏳ Carregando...", action: nil, keyEquivalent: "")
            loadingItem.isEnabled = false
            menu.addItem(loadingItem)
            menu.addItem(NSMenuItem.separator())
        }
        
        // Partições EFI
        if efiService.partitions.isEmpty {
            let noPartitionsItem = NSMenuItem(title: "Nenhuma partição EFI encontrada", action: nil, keyEquivalent: "")
            noPartitionsItem.isEnabled = false
            menu.addItem(noPartitionsItem)
        } else {
            // Título das partições
            let partitionsHeader = NSMenuItem()
            partitionsHeader.attributedTitle = NSAttributedString(
                string: "Partições EFI (\(efiService.partitions.count))",
                attributes: [
                    .font: NSFont.menuBarFont(ofSize: 12).withTraits(.bold),
                    .foregroundColor: NSColor.secondaryLabelColor
                ]
            )
            partitionsHeader.isEnabled = false
            menu.addItem(partitionsHeader)
            
            // Partition list
            for (index, partition) in efiService.partitions.enumerated() {
                let partitionMenu = createPartitionSubmenu(for: partition, at: index)
                let partitionItem = NSMenuItem()
                partitionItem.title = "\(partition.deviceName)"
                partitionItem.submenu = partitionMenu
                menu.addItem(partitionItem)
            }
        }
        
        menu.addItem(NSMenuItem.separator())
        
        // Main actions
        let discoverItem = NSMenuItem(
            title: "Discover Partitions",
            action: #selector(discoverPartitions),
            keyEquivalent: "r"
        )
        discoverItem.target = self
        discoverItem.isEnabled = !efiService.isLoading
        menu.addItem(discoverItem)
        
        let refreshSystemItem = NSMenuItem(
            title: "Update System",
            action: #selector(refreshSystemInfo),
            keyEquivalent: "i"
        )
        refreshSystemItem.target = self
        refreshSystemItem.isEnabled = !efiService.isLoading
        menu.addItem(refreshSystemItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Main window
        let showMainWindowItem = NSMenuItem(
            title: "Show Main Window",
            action: #selector(showMainWindow),
            keyEquivalent: "m"
        )
        showMainWindowItem.target = self
        menu.addItem(showMainWindowItem)
        
        // System information
        let systemInfoItem = NSMenuItem(
            title: "System Information",
            action: #selector(showSystemInfo),
            keyEquivalent: "s"
        )
        systemInfoItem.target = self
        menu.addItem(systemInfoItem)
        
        // Help
        let helpItem = NSMenuItem(
            title: "Help",
            action: #selector(showHelp),
            keyEquivalent: "h"
        )
        helpItem.target = self
        menu.addItem(helpItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Settings
        let settingsSubmenu = NSMenu()
        
        // Toggle Dock Icon
        let dockIconItem = NSMenuItem(
            title: NSApp.activationPolicy() == .regular ? "Hide Dock Icon" : "Show Dock Icon",
            action: #selector(toggleDockIcon),
            keyEquivalent: "d"
        )
        dockIconItem.target = self
        settingsSubmenu.addItem(dockIconItem)
        
        // Launch at startup
        let launchAtStartupItem = NSMenuItem(
            title: "Launch at Startup",
            action: #selector(toggleLaunchAtStartup),
            keyEquivalent: ""
        )
        launchAtStartupItem.target = self
        launchAtStartupItem.state = isLaunchAtStartupEnabled() ? .on : .off
        settingsSubmenu.addItem(launchAtStartupItem)
        
        let settingsItem = NSMenuItem()
        settingsItem.title = "Settings"
        settingsItem.submenu = settingsSubmenu
        menu.addItem(settingsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Last service message
        if !efiService.lastMessage.isEmpty {
            let messageItem = NSMenuItem()
            messageItem.attributedTitle = NSAttributedString(
                string: "Status: \(efiService.lastMessage)",
                attributes: [
                    .font: NSFont.menuBarFont(ofSize: 11),
                    .foregroundColor: NSColor.tertiaryLabelColor
                ]
            )
            messageItem.isEnabled = false
            menu.addItem(messageItem)
            menu.addItem(NSMenuItem.separator())
        }
        
        // Quit
        let quitItem = NSMenuItem(
            title: "Quit EFI Mount Tool",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    // MARK: - Create submenu for partition
    private func createPartitionSubmenu(for partition: EFIPartition, at index: Int) -> NSMenu {
        let submenu = NSMenu()
        
        // Partition status
        let statusItem = NSMenuItem()
        let statusText = partition.isMounted ? "Mounted: \(partition.mountPoint)" : "Not mounted"
        statusItem.attributedTitle = NSAttributedString(
            string: statusText,
            attributes: [
                .font: NSFont.menuBarFont(ofSize: 11),
                .foregroundColor: partition.isMounted ? NSColor.systemGreen : NSColor.systemRed
            ]
        )
        statusItem.isEnabled = false
        submenu.addItem(statusItem)
        
        // Partition size
        let sizeItem = NSMenuItem(title: "Disk: \(partition.diskName)", action: nil, keyEquivalent: "")
        sizeItem.isEnabled = false
        submenu.addItem(sizeItem)
        
        submenu.addItem(NSMenuItem.separator())
        
        if partition.isMounted {
            // Open in Finder
            let openFinderItem = NSMenuItem(
                title: "Open in Finder",
                action: #selector(openPartitionInFinder(_:)),
                keyEquivalent: ""
            )
            openFinderItem.target = self
            openFinderItem.representedObject = partition
            openFinderItem.isEnabled = !efiService.isLoading
            submenu.addItem(openFinderItem)
            
            // Unmount
            let unmountItem = NSMenuItem(
                title: "Unmount Partition",
                action: #selector(unmountPartition(_:)),
                keyEquivalent: ""
            )
            unmountItem.target = self
            unmountItem.representedObject = index
            unmountItem.isEnabled = !efiService.isLoading
            submenu.addItem(unmountItem)
        } else {
            // Mount
            let mountItem = NSMenuItem(
                title: "Mount Partition",
                action: #selector(mountPartition(_:)),
                keyEquivalent: ""
            )
            mountItem.target = self
            mountItem.representedObject = index
            mountItem.isEnabled = !efiService.isLoading
            submenu.addItem(mountItem)
        }
        
        submenu.addItem(NSMenuItem.separator())
        
        // Copy path
        let copyPathItem = NSMenuItem(
            title: "Copy Path",
            action: #selector(copyPartitionPath(_:)),
            keyEquivalent: ""
        )
        copyPathItem.target = self
        copyPathItem.representedObject = partition.devicePath
        submenu.addItem(copyPathItem)
        
        return submenu
    }
    
    // MARK: - Menu Actions
    
    @objc private func discoverPartitions() {
        Task {
            await efiService.discoverPartitions()
        }
    }
    
    @objc private func refreshSystemInfo() {
        Task {
            await efiService.updateSystemInfo()
        }
    }
    
    @objc private func mountPartition(_ sender: NSMenuItem) {
        guard let index = sender.representedObject as? Int else { return }
        Task {
            await efiService.mountPartition(at: index)
        }
    }
    
    @objc private func unmountPartition(_ sender: NSMenuItem) {
        guard let index = sender.representedObject as? Int else { return }
        Task {
            await efiService.unmountPartition(at: index)
        }
    }
    
    @objc private func openPartitionInFinder(_ sender: NSMenuItem) {
        guard let partition = sender.representedObject as? EFIPartition else { return }
        efiService.openEFIInFinder(partition: partition)
    }
    
    @objc private func copyPartitionPath(_ sender: NSMenuItem) {
        guard let path = sender.representedObject as? String else { return }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(path, forType: .string)
        
        // Show notification
        showNotification(title: "Path Copied", message: "Partition path copied to clipboard")
    }
    
    @objc private func showMainWindow() {
        // Activate application and show main window
        NSApp.activate(ignoringOtherApps: true)
        for window in NSApp.windows {
            if window.title.contains("EFI") || window.contentViewController != nil {
                window.makeKeyAndOrderFront(nil)
                return
            }
        }
    }
    
    @objc private func showSystemInfo() {
        // Mostrar janela principal e navegar para informações do sistema
        showMainWindow()
        // Simular comando para mostrar info do sistema
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Enviar notificação customizada para abrir system info
            NotificationCenter.default.post(name: NSNotification.Name("ShowSystemInfo"), object: nil)
        }
    }
    
    @objc private func showHelp() {
        // Mostrar janela principal e navegar para ajuda
        showMainWindow()
        // Simular comando para mostrar ajuda
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Enviar notificação customizada para abrir ajuda
            NotificationCenter.default.post(name: NSNotification.Name("ShowHelp"), object: nil)
        }
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
    
    @objc private func toggleDockIcon() {
        if NSApp.activationPolicy() == .regular {
            // Ocultar ícone do dock
            NSApp.setActivationPolicy(.accessory)
            showNotification(title: "EFI Mount Tool", message: "Ícone do Dock ocultado. Use o menu da barra superior para acessar.")
        } else {
            // Mostrar ícone do dock
            NSApp.setActivationPolicy(.regular)
            showNotification(title: "EFI Mount Tool", message: "Ícone do Dock visível novamente.")
        }
    }
    
    @objc private func toggleLaunchAtStartup() {
        // Implementação simplificada - em uma implementação real usaria ServiceManagement framework
        showNotification(title: "Configuração", message: "Funcionalidade de inicialização automática será implementada em versão futura.")
    }
    
    private func isLaunchAtStartupEnabled() -> Bool {
        // Placeholder - implementação real verificaria LoginItems
        return false
    }
    
    // MARK: - Notificações
    private func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao mostrar notificação: \(error)")
            }
        }
    }
}

// MARK: - NSFont Extension
extension NSFont {
    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits) -> NSFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return NSFont(descriptor: descriptor, size: 0) ?? self
    }
}
