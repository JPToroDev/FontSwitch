//
// GeneralSettings.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct GeneralSettings: View {
    @Environment(TypefaceManager.self) private var typefaceManager
    @Environment(PermissionManager.self) private var permissionsManager
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Form {
            accessibilityInformation
            keyboardNavigationInformation
            keyboardShortcutInformation
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .task(id: scenePhase) {
            await permissionsManager.checkAccessibilityAccess()
        }
    }

    @ViewBuilder private var accessibilityInformation: some View {
        if permissionsManager.hasAccessibilityAccess {
            LabeledContent("Accessibility Access") {
                Text("Granted")
                    .foregroundStyle(.primary)
                Image(systemName: "checkmark")
                    .symbolVariant(.circle.fill)
                    .foregroundStyle(.green)
            }
        } else {
            LabeledContent {
                Button("Accessibility Settings...", action: openSystemPreferences)
            } label: {
                Text("Permission")
                Text("To use this app, please ensure Accessibility Access is enabled.")
            }
        }
    }

    private var keyboardNavigationInformation: some View {
        LabeledContent {
            Button("Keyboard Settings...", action: openKeyboardSettings)
        } label: {
            Text("Keyboard Navigation")
            Text("Enable this setting to navigate through the interface using Tab.")
        }
    }

    private var keyboardShortcutInformation: some View {
        Section {
            LabeledContent("Toggle App", value: "⌃F")
            LabeledContent("Focus Search", value: "⌃S")
        }
    }

    // MARK: - METHODS

    private func openKeyboardSettings() {
        if let url = URL(string: K.keyboardSettingsURLScheme) {
            openURL(url)
        }
    }

    private func openSystemPreferences() {
        if let url = URL(string: K.accessibilitySettingsURLScheme) {
            openURL(url)
        }
    }
}

#Preview {
    TabView {
        Tab("General", systemImage: "gear") {
            GeneralSettings()
        }
    }
    .environment(TypefaceManager())
    .environment(PermissionManager())
    .frame(width: 400)
}
