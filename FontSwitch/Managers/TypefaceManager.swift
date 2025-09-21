//
// TypefaceManager.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//
import AppKit

@Observable
final class TypefaceManager {
    private enum FontCollectionAction {
        case add, remove
    }

    var collections = [String]()
    var allFonts = [FontData]()
    var visibleFonts = [FontData]()
    private var hiddenFonts = [FontData]()

    init() {
        refreshFontData()
    }

    func hide(_ fonts: Set<FontData>) {
        hiddenFonts += fonts
        hiddenFonts.sort { $0.name < $1.name }
        let hiddenFontNames = hiddenFonts.map(\.name)
        UserDefaults.standard.setValue(hiddenFontNames, forKey: K.Default.hiddenFonts)
        refreshFontData()
    }

    func show(_ fonts: Set<FontData>) {
        hiddenFonts = hiddenFonts.filter { !fonts.contains($0) }
        let hiddenFontNames = hiddenFonts.map(\.name)
        UserDefaults.standard.setValue(hiddenFontNames, forKey: K.Default.hiddenFonts)
        refreshFontData()
    }

    func getFontCollections() {
        let allCollectionNames = NSFontCollection.allFontCollectionNames
        // Filter out any odd fonts required by the system
        let regularCollections = allCollectionNames.filter { !$0.rawValue.contains("com.apple") }
        let collectionNames = regularCollections.map(\.rawValue)
        collections = collectionNames
    }

    func getFonts(in collection: String?) -> [FontData] {
        guard let fontCollection = collection else { return visibleFonts }
        let collectionName = NSFontCollection.Name(fontCollection)
        let collection = NSFontCollection(name: collectionName)
        var fonts = [FontData]()
        guard let descriptors = collection?.matchingDescriptors else { return [] }
        for descriptor in descriptors {
            let font = NSFont(descriptor: descriptor, size: 10)
            guard let family = font?.familyName else { continue }
            guard !fonts.contains(where: { $0.name == family }) else { continue }
            guard !hiddenFonts.contains(where: { $0.name == family }) else { continue }
            let fontData = getData(for: family)
            fonts.append(fontData)
        }
        return fonts
    }

    func remove(_ fonts: some Collection<FontData>, from collection: String) {
        update(fonts, collection: collection, action: .remove)
    }

    func add(_ fonts: some Collection<FontData>, to collection: String) {
        update(fonts, collection: collection, action: .add)
    }

    func createCollection(named name: String) {
        let collection = NSFontCollection(descriptors: [])
        let collectionName = NSFontCollection.Name(name)
        show(collection, withName: collectionName)
    }

    func renameCollection(from oldName: String, to newName: String) {
        let oldName = NSFontCollection.Name(oldName)
        let newName = NSFontCollection.Name(newName)
        do {
            try NSFontCollection.rename(fromName: oldName, visibility: .user, toName: newName)
        } catch {
            print("Error renaming collection: \(error.localizedDescription)")
        }
    }

    func deleteCollection(named name: String) {
        let collectionName = NSFontCollection.Name(name)
        do {
            try NSFontCollection.hide(withName: collectionName, visibility: .user)
        } catch {
            print("Error removing collection: \(error.localizedDescription)")
        }
    }

    func changeFont(to font: String) async {
        let pasteboard = NSPasteboard.general
        let archive = pasteboard.saveContents()
        pasteboard.clearContents()
        triggerKeyPress(8, useCommandFlag: true)
        // Give the system a moment to copy the selected text to clipboard
        // before applying the new font, otherwise we'll format the wrong item.
        try? await Task.sleep(for: .seconds(0.15))
        guard let text = convertRichTextToAttributedString(with: font) else { return }
        copyToPasteboard(text)
        triggerKeyPress(9, useCommandFlag: true)
        try? await Task.sleep(for: .seconds(0.15))
        pasteboard.restore(archive: archive)
    }

    func hidePreHiddenFonts() {
        let allFonts = Set(NSFontManager.shared.availableFontFamilies)
        let preHiddenFontsOnSystem = allFonts.intersection(K.preHiddenFonts)
        let alphabetizedFonts = preHiddenFontsOnSystem.sorted { $0 < $1 }
        UserDefaults.standard.setValue(Array(alphabetizedFonts), forKey: K.Default.hiddenFonts)
    }

    private func refreshFontData() {
        getFontCollections()
        getAllFonts()
        getHiddenFonts()
        getVisibleFonts()
    }

    private func getAllFonts() {
        let availableFonts = NSFontManager.shared.availableFontFamilies
        allFonts = availableFonts.map { getData(for: $0) }
    }

    private func getHiddenFonts() {
        hiddenFonts = allFonts.filter { $0.isVisible == false }
    }

    private func getVisibleFonts() {
        visibleFonts = allFonts.filter { $0.isVisible == true }
    }

    private func getData(for font: String) -> FontData {
        let hiddenFontsArray = UserDefaults.standard.array(forKey: K.Default.hiddenFonts) as? [String] ?? []
        let isVisible = !hiddenFontsArray.contains(font)
        let collections = getAssociatedCollections(for: font)
        let fontData = FontData(name: font, isVisible: isVisible, collections: collections)
        return fontData
    }

    private func getAssociatedCollections(for fontName: String) -> [String] {
        var fontCollections = [String]()
        for collection in collections {
            let collectionName = NSFontCollection.Name(collection)
            let fontCollection = NSFontCollection(name: collectionName)
            guard let descriptors = fontCollection?.matchingDescriptors else { continue }

            for descriptor in descriptors {
                let font = NSFont(descriptor: descriptor, size: 10)
                guard let family = font?.familyName,
                      family == fontName,
                      !fontCollections.contains(collection)
                else { continue }
                fontCollections.append(collection)
            }
        }

        return fontCollections
    }

    private func show(_ collection: NSFontCollection, withName name: NSFontCollection.Name) {
        do {
            try NSFontCollection.show(collection, withName: name, visibility: .user)
        } catch {
            print("Error updating collection: \(error.localizedDescription)")
        }
    }

    private func update(_ fonts: some Collection<FontData>, collection: String, action: FontCollectionAction) {
        let collectionName = NSFontCollection.Name(collection)
        guard let fontCollection = NSMutableFontCollection(name: collectionName) else { return }
        for font in fonts.map(\.name) {
            let descriptor = NSFontDescriptor(fontAttributes: [.family: font])
            if action == .add {
                fontCollection.addQuery(for: [descriptor])
            } else {
                fontCollection.removeQuery(for: [descriptor])
            }
        }
        show(fontCollection, withName: collectionName)
        refreshFontData()
    }

    private func triggerKeyPress(_ keyCode: CGKeyCode, useCommandFlag: Bool) {
        guard let source = CGEventSource(stateID: .combinedSessionState) else {
            NSLog("Programmatic key press")
            return
        }

        let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true)
        if useCommandFlag { keyDownEvent?.flags = .maskCommand }
        let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false)

        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
        refreshFontData()
    }

    private func convertRichTextToAttributedString(with font: String) -> NSAttributedString? {
        guard let data = NSPasteboard.general.data(forType: .rtf),
              let attributedString = NSMutableAttributedString(rtf: data, documentAttributes: nil)
        else {
            return nil
        }

        guard let font = NSFont(name: font, size: 10) else { return nil }
        attributedString.setFont(font)
        return attributedString
    }

    private func copyToPasteboard(_ attrString: NSAttributedString) {
        do {
            let attributeKey = NSAttributedString.DocumentAttributeKey.documentType
            let documentType = NSAttributedString.DocumentType.rtf
            let documentAttributes = [attributeKey: documentType]
            let fullRange = NSRange(location: 0, length: attrString.length)
            let rtfData = try attrString.data(from: fullRange, documentAttributes: documentAttributes)
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setData(rtfData, forType: .rtf)
        } catch {
            print("Error creating RTF from AttributedString: \(error.localizedDescription)")
        }
    }
}
