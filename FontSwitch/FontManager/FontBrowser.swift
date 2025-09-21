//
// FontBrowser.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct FontBrowser: View {
    @Binding var selectedCollection: String
    @Environment(TypefaceManager.self) private var typefaceManager
    @State private var visibilityFilter = FontVisibility.all
    @State private var selectedFonts = Set<FontData>()
    private let rowHeight = 15.0

    private var filteredFonts: [FontData] {
        let baseFonts = selectedCollection == "All Fonts"
            ? typefaceManager.allFonts
            : typefaceManager.allFonts.filter { $0.collections.contains(selectedCollection) }

        return switch visibilityFilter {
        case .all: baseFonts
        case .visible: baseFonts.filter(\.isVisible)
        case .hidden: baseFonts.filter { !$0.isVisible }
        }
    }

    var body: some View {
        ListAccessoryView {
            List(selection: $selectedFonts) {
                ForEach(filteredFonts, id: \.self) { font in
                    row(for: font)
                        .frame(height: rowHeight)
                        .listRowSeparator(.hidden)
                        .draggable(font) {
                            CustomFontRow(fontName: font.name)
                                .font(.footnote)
                                .frame(height: rowHeight)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 5)
                                .background(.secondary, in: .rect(cornerRadius: 5, style: .continuous))
                        }
                        .contextMenu {
                            addSelectionsToCollectionButton
                            removeSelectionsFromCollectionButton
                            hideSelectionsButton
                            showSelectionsButton
                        }
                }
            }
        } header: {
            header
        }
        .onExitCommand(perform: clearSelections)
    }

    private func row(for font: FontData) -> some View {
        HStack {
            CustomFontRow(fontName: font.name)
                .foregroundStyle(font.isVisible ? .primary : .secondary)

            let newCollections = font.collections.filter { $0 != "All Fonts" && $0 != selectedCollection }
            ForEach(newCollections, id: \.self) { collection in
                PillView(text: collection)
            }

            Button("Toggle Visibility", systemImage: "eye") {
                toggleVisibility(font)
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .imageScale(.small)
            .symbolVariant(font.isVisible ? .none : .slash)
            .foregroundStyle(font.isVisible ? .primary : .secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var addSelectionsToCollectionButton: some View {
        Menu("Add to Collection", systemImage: "rectangle.stack.badge.plus") {
            ForEach(typefaceManager.collections, id: \.self) { collection in
                Button(collection) {
                    add(selectedFonts, to: collection)
                }
            }
        }
    }

    private var removeSelectionsFromCollectionButton: some View {
        Menu("Remove from Collection", systemImage: "rectangle.stack.badge.minus") {
            ForEach(typefaceManager.collections, id: \.self) { collection in
                Button(collection) {
                    remove(selectedFonts, from: collection)
                }
            }
        }
    }

    private var hideSelectionsButton: some View {
        Button("Hide", systemImage: "eye.slash") {
            typefaceManager.hide(selectedFonts)
            clearSelections()
        }
    }

    private var showSelectionsButton: some View {
        Button("Show", systemImage: "eye") {
            typefaceManager.show(selectedFonts)
            clearSelections()
        }
    }

    private var header: some View {
        HStack {
            Text("Fonts")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                ForEach(FontVisibility.allCases, id: \.self) { visibility in
                    Toggle(visibility.description, isOn: bindingForOption(visibility))
                }
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease")
                    .contentShape(.circle)
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .symbolVariant(visibilityFilter == .all ? .circle : .circle.fill)
            .foregroundStyle(visibilityFilter == .all ? Color.secondary : Color.accent)
        }
    }

    private func toggleVisibility(_ font: FontData) {
        if font.isVisible {
            typefaceManager.hide([font])
        } else {
            typefaceManager.show([font])
        }
    }

    private func add(_ fonts: Set<FontData>, to collection: String) {
        typefaceManager.add(fonts, to: collection)
        clearSelections()
    }

    private func remove(_ fonts: Set<FontData>, from collection: String) {
        typefaceManager.remove(fonts, from: collection)
        clearSelections()
    }

    private func clearSelections() {
        selectedFonts = []
    }

    private func bindingForOption(_ option: FontVisibility) -> Binding<Bool> {
        Binding(
            get: { visibilityFilter == option },
            set: { if $0 { visibilityFilter = option } }
        )
    }
}
