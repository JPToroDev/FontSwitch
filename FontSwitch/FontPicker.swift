//
// FontSwitcher.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import HotKey
import SwiftUI

struct FontPicker: View {
    @AppStorage(K.Default.selectedCollection)
    private var selectedCollection: String?

    @Environment(TypefaceManager.self) private var typefaceManager
    @Environment(\.openSettings) private var openSettings
    @Environment(\.focusMainWindow) private var focusMainWindow
    @Environment(\.unfocusMainWindow) private var unfocusMainWindow

    @State private var searchText = ""
    @State private var selectedFont: FontData?
    @State private var searchIsActive = false
    @State private var allFonts = [FontData]()
    @State private var listID = UUID()

    @FocusState private var focusedField: FocusedField?
    private let searchShortcut = HotKey(key: .s, modifiers: [.control])

    private var filteredFonts: [FontData] {
        allFonts.filter { font in
            searchText.isEmpty || font.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ScrollViewReader { reader in
            // Using VStack instead of safeAreaInset() prevents the list's
            // background from bleeding behind the header and footer areas,
            // which can cause issues with translucent styles like Material.
            VStack(spacing: 0) {
                FontSwitcherHeader(selectedCollection: $selectedCollection, focusedField: $focusedField)
                    .background(.thickMaterial)

                List(selection: $selectedFont) {
                    ForEach(filteredFonts) { font in
                        CustomFontRow(fontName: font.name)
                            .tag(font)
                            .frame(maxHeight: 15)
                            .listRowSeparator(.hidden)
                            .contextMenu {
                                Button("Hide") { hide(font: font) }
                                Divider()
                                addToCollectionMenu(font: font)
                                removeFromCollectionButton(font: font)
                            }
                    }
                }
                .id(listID) // Resets scroll position to top
                .padding(.horizontal, 8)
                .scrollContentBackground(.hidden)
                .background(.thickMaterial)
                .scrollIndicators(.hidden)
                .task(id: selectedCollection, loadSelectedCollection)

                searchField
                    .background(.thickMaterial)
                    .onSubmit {
                        Task { reader.scrollTo(selectedFont) }
                        applyFont()
                    }
            }
            .onAppear(perform: setupSearchShortcut)
            .onChange(of: selectedFont) {
                guard !searchIsActive else {
                    reader.scrollTo(selectedFont)
                    return
                }
                applyFont()
            }
        }
    }

    private func addToCollectionMenu(font: FontData) -> some View {
        Menu("Add to Collection...") {
            ForEach(typefaceManager.collections, id: \.self) { collection in
                Button(collection) {
                    typefaceManager.add([font], to: collection)
                }
            }
        }
    }

    func removeFromCollectionButton(font: FontData) -> some View {
        Button("Remove from Current Collection") {
            guard let selectedCollection else { return }
            typefaceManager.remove([font], from: selectedCollection)
        }
        .disabled(selectedCollection == nil)
    }

    private var searchField: some View {
        TextField("Search", text: $searchText)
            .focused($focusedField, equals: .searchBar)
            .textFieldStyle(.roundedBorder)
            .padding([.horizontal, .bottom])
            // Key presses are recognized when only this view has focus.
            // Other focusable views need their own modifiers.
            .onKeyPress(phases: [.down, .repeat], action: handleKeyPress)
            .onChange(of: focusedField, handleFocusChange)
            .onChange(of: searchText) { _, newText in
                guard !newText.isEmpty else { return }
                selectedFont = filteredFonts.first
            }
    }

    // MARK: - METHODS

    private func handleKeyPress(_ keyPress: KeyPress) -> KeyPress.Result {
        switch keyPress.key {
        case .upArrow:
            navigateUp()
        case .downArrow:
            navigateDown()
        case .escape:
            resetSearchField()
        default:
            return .ignored
        }
        return .handled
    }

    private func handleFocusChange() {
        searchIsActive = focusedField == .searchBar
        if focusedField == nil {
            unfocusMainWindow()
        } else {
            focusMainWindow()
        }
    }

    private func applyFont() {
        resetSearchField()
        guard let selectedFont else { return }
        Task { await typefaceManager.changeFont(to: selectedFont.name) }
    }

    private func hide(font: FontData) {
        typefaceManager.hide([font])
        allFonts = typefaceManager.visibleFonts
    }

    private func loadSelectedCollection() {
        allFonts = typefaceManager.getFonts(in: selectedCollection)
        listID = UUID()
    }

    private func resetSearchField() {
        focusedField = nil
        searchText = ""
    }

    private func navigateDown() {
        if let currentFont = selectedFont, let currentIndex = filteredFonts.firstIndex(of: currentFont) {
            let fontCount = filteredFonts.count
            let nextIndex = currentIndex < fontCount - 1 ? currentIndex + 1 : 0
            selectedFont = filteredFonts[nextIndex]
        } else {
            selectedFont = filteredFonts.first
        }
    }

    private func navigateUp() {
        if let currentFont = selectedFont, let currentIndex = filteredFonts.firstIndex(of: currentFont) {
            let fontCount = filteredFonts.count
            let nextIndex = currentIndex > 0 ? currentIndex - 1 : fontCount - 1
            selectedFont = filteredFonts[nextIndex]
        } else {
            selectedFont = filteredFonts.last
        }
    }

    private func setupSearchShortcut() {
        searchShortcut.keyUpHandler = {
            focusMainWindow()
            focusedField = .searchBar
        }
    }
}
