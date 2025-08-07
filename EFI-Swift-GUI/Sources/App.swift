import SwiftUI
import UserNotifications

// MARK: - App Configuration
struct AppConstants {
    static let version = "1.2.1"
    static let appName = "EFI Mount Tool"
    static let bundleIdentifier = "com.menthorz.efi-mount-tool"
}

// Singleton para manter a referência do MenuBarManager
class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarManager: MenuBarManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Configurações adicionais se necessário
    }
}

@main
struct EFISwiftGUIApp: App {
    @StateObject private var efiService = EFIService()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Solicitar permissão para notificações
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(efiService)
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    // Inicializar menu bar manager e manter referência
                    if appDelegate.menuBarManager == nil {
                        appDelegate.menuBarManager = MenuBarManager(efiService: efiService)
                    }
                }
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            // Menu da aplicação
            CommandGroup(after: .appInfo) {
                Button("Mostrar/Ocultar Menu Bar") {
                    // Toggle menu bar visibility se necessário
                }
                .keyboardShortcut("b", modifiers: [.command])
            }
            
            // Menu de ações EFI
            CommandMenu("EFI") {
                Button("Descobrir Partições") {
                    Task {
                        await efiService.discoverPartitions()
                    }
                }
                .keyboardShortcut("r", modifiers: [.command])
                
                Button("Atualizar Sistema") {
                    Task {
                        await efiService.updateSystemInfo()
                    }
                }
                .keyboardShortcut("i", modifiers: [.command])
            }
        }
    }
}
