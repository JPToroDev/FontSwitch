//
// UpdateSettings.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct UpdateSettings: View {
    @AppStorage(K.Default.automaticallyChecksForUpdates)
    private var automaticallyChecksForUpdates = false

    @AppStorage(K.Default.subscribedToBetaUpdates)
    private var subscribeToBetaUpdates = false

    @Environment(UpdateManager.self) private var updateManager

    private let channelDetails = """
    To try new features before each official release, choose “Beta”. \
    Note that beta versions may have bugs that cause crashes.
    """

    private var lastCheckedDate: String {
        updateManager.lastUpdateCheckDate?.formatted(.relativeDateTime) ?? "Never"
    }

    var body: some View {
        Form {
            Section {
                Toggle("Check for Updates Automatically", isOn: $automaticallyChecksForUpdates)

                LabeledContent("Last Checked: \(lastCheckedDate)") {
                    Button("Check for Updates", action: updateManager.checkForUpdates)
                        .disabled(!updateManager.canCheckForUpdates)
                }
            }

            Section {
                Picker("Release Channel", selection: $subscribeToBetaUpdates) {
                    Text("Production").tag(false)
                    Text("Beta").tag(true)
                }
            } footer: {
                Text(channelDetails)
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
        .onChange(of: automaticallyChecksForUpdates) { _, newValue in
            updateManager.automaticallyChecksForUpdates = newValue
        }
    }
}

#Preview {
    TabView {
        Tab("Updates", systemImage: "arrow.down.circle") {
            UpdateSettings()
        }
    }
    .environment(UpdateManager())
    .frame(width: 400)
}
