//
// RightClickMenu.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct RightClickMenu: View {
    @Environment(UpdateManager.self) private var updateManager
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Check for Update...", action: updateManager.checkForUpdates)
            .disabled(updateManager.canCheckForUpdates)
            .keyboardShortcut("u")

        Button("Font Manager...") {
            openWindow(id: K.fontManagerWindowID)
        }
        .keyboardShortcut("d")

        SettingsLink()
            .labelStyle(.titleOnly)
            .keyboardShortcut(",")

        Divider()

        Button("Quit") { NSApp.terminate(nil) }
            .keyboardShortcut("q")
    }
}
