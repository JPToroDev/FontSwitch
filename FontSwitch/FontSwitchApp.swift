//
// FontSwitchApp.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

@main
struct FontSwitchApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Window("Font Manager", id: K.fontManagerWindowID) {
           FontManagerView()
                .frame(minHeight: 400)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .toolbarBackground(.hidden, for: .windowToolbar)
                .environment(appDelegate.typefaceManager)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentSize)

        Settings {
            SettingsView()
                .frame(width: 400)
                .environment(appDelegate.updateManager)
                .environment(appDelegate.typefaceManager)
                .environment(appDelegate.permissionManager)
        }
    }
}
