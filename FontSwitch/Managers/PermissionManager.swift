//
// PermissionsManager.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

@preconcurrency import Cocoa
import Observation

@Observable
final class PermissionManager {
    private(set) var hasAccessibilityAccess = AXIsProcessTrusted()

    @MainActor func checkAccessibilityAccess() async {
        // For some reason the app hangs without this delay
        try? await Task.sleep(for: .seconds(1))
        hasAccessibilityAccess = AXIsProcessTrusted()
        guard !hasAccessibilityAccess else { return }
        await checkAccessibilityAccess()
    }

    // Presents the accessibility permissions dialog
    static func requestAccessibilityPrivileges() {
        let hasAlreadyLaunched = UserDefaults.standard.bool(forKey: K.Default.appHasPreviouslyLaunched)
        guard !hasAlreadyLaunched else { return }
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        _ = AXIsProcessTrustedWithOptions(options)
    }
}
