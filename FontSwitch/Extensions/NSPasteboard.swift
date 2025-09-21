//
// NSPasteboard.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import AppKit

extension NSPasteboard {
    // We change the selected text's font by programmatically
    // copying it to the pasteboard, so we need to save the
    // current contents first to restore them later.
    func saveContents() -> [any NSPasteboardWriting] {
        var archive = [any NSPasteboardWriting]()
        pasteboardItems?.forEach { item in
            let archivedItem = NSPasteboardItem()
            types?.forEach { type in
                if let data = item.data(forType: type) {
                    archivedItem.setData(data, forType: type)
                }
            }
            archive.append(archivedItem)
        }
        return archive
    }

    func restore(archive: [any NSPasteboardWriting]) {
        clearContents()
        writeObjects(archive)
    }
}
