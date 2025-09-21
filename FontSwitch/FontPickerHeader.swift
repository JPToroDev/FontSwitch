//
// FontSwitcherHeader.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct FontSwitcherHeader: View {
    @Environment(TypefaceManager.self) private var typefaceManager
    @Environment(\.openSettings) private var openSettings
    @Environment(\.openWindow) private var openWindow
    @Binding var selectedCollection: String?
    var focusedField: FocusState<FocusedField?>.Binding

    var body: some View {
        HStack {
            collectionPicker
            Spacer()
            moreMenu
        }
        .padding([.horizontal, .top])
    }

    // Picker's currentValueLabel parameter doesn't support custom backgrounds,
    // so we wrap the Picker in a Menu to customize the label appearance.
    // Note: Using Section nested inside Menu or Picker can cause rendering issues
    // like missing headers, but that doesn't apply to our implementation here.
    private var collectionPicker: some View {
        Menu {
            Picker("Collection", selection: $selectedCollection) {
                Text("All Fonts").tag(nil as String?)
                Divider()
                ForEach(typefaceManager.collections, id: \.self) { collection in
                    Text(collection)
                        .tag(collection, includeOptional: true)
                }
            }
            .labelsHidden() // Prevents the label from appearing as a section header
            .pickerStyle(.inline) // Prevents the Picker from appearing as a nested Menu
        } label: {
            pickerLabel
        }
        .buttonStyle(.plain)
        .focused(focusedField, equals: .collectionPicker)
    }

    private var pickerLabel: some View {
        HStack(spacing: 3) {
            Text(selectedCollection ?? "All Fonts")
            Image(systemName: "chevron.up.chevron.down")
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .imageScale(.small)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(.quinary, in: .capsule)
        .contentShape(.capsule) // Adjusts focus ring shape
    }

    private var moreMenu: some View {
        Menu {
            Group {
                Button("Settings...", systemImage: "gear") {
                    openSettings()
                }
                Button("Font Manager...", systemImage: "textformat") {
                    openWindow(id: K.fontManagerWindowID)
                }
            }
            .labelStyle(.titleAndIcon)
        } label: {
            Label("More", systemImage: "gear")
                .labelStyle(.iconOnly)
                .contentShape(.circle) // Adjusts focus ring shape; does not work directly on Menu
        } primaryAction: {
            openSettings()
        }
        .foregroundStyle(.secondary)
        .buttonStyle(.plain)
        .focused(focusedField, equals: .settingsButton)
        .onKeyPress(.tab) {
            // The system should automatically assign focus to the search bar,
            // but that doesn't happen here. Appears to be a bug.
            focusedField.wrappedValue = .searchBar
            return .handled
        }
    }
}
