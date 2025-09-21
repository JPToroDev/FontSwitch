//
// SettingsView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            Tab("General", systemImage: "gearshape") {
                GeneralSettings()
                    .fixedSize(horizontal: false, vertical: true)
            }

            Tab("Updates", systemImage: "arrow.down.circle") {
                UpdateSettings()
                    .fixedSize(horizontal: false, vertical: true)
            }

            Tab("Info", systemImage: "info.circle") {
                AboutView()
                    .padding()
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    SettingsView()
        .frame(width: 400)
        .environment(TypefaceManager())
        .environment(UpdateManager())
        .environment(PermissionManager())
}
