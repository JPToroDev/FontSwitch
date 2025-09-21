//
// ContentView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//
import SwiftUI

struct ContentView: View {
    @Environment(PermissionManager.self) private var permissionManager

    var body: some View {
        Group {
            if permissionManager.hasAccessibilityAccess {
                FontPicker()
            } else {
                NoAccessView()
            }
        }
        .frame(width: 200)
        .frame(minHeight: 250, maxHeight: 500)
        .clipShape(.rect(cornerRadius: 25, style: .continuous))
        .task { await permissionManager.checkAccessibilityAccess() }
    }
}

#Preview {
    ContentView()
        .environment(PermissionManager())
        .environment(UpdateManager())
        .environment(TypefaceManager())
}
