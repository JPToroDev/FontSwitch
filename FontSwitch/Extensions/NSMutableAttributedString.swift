//
// NSMutableAttributedString.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import AppKit

extension NSMutableAttributedString {
    func setFont(_ font: NSFont) {
        guard let fontFamilyName = font.familyName else { return }
        beginEditing()

        let fullRange = NSRange(location: 0, length: length)
        enumerateAttribute(.font, in: fullRange, options: []) { value, range, _ in
            guard let oldFont = value as? NSFont else { return }
            let descriptor = oldFont
                .fontDescriptor
                .withFamily(fontFamilyName)
                .withSymbolicTraits(oldFont.fontDescriptor.symbolicTraits)
            let newFont = NSFont(descriptor: descriptor, size: oldFont.pointSize) ?? oldFont
            addAttribute(.font, value: newFont, range: range)
        }

        endEditing()
    }
}
