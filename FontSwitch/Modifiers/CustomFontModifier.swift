//
// CustomFontModifier.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct CustomFont: ViewModifier {
    var name: String
    var style: NSFont.TextStyle
    var weight: Font.Weight = .regular
    @State private var baseline = 0.0

    private var font: Font! {
        let size = NSFont.preferredFont(forTextStyle: style).pointSize
        return if K.specialFonts.contains(name) {
            .system(size: size)
        } else {
            .custom(name, size: size).weight(weight)
        }
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .baselineOffset(-baseline)
            .onAppear(perform: calculateBaseline)
    }

    // Ensures text rendered with this font sits correctly in the view.
    // Sometimes extreme ascenders or descenders can throw this off.
    private func calculateBaseline() {
        guard !K.specialFonts.contains(name) else { return }
        let controlSize = NSFont.preferredFont(forTextStyle: .body).pointSize
        guard let customFont = NSFont(name: name, size: controlSize) else { return }
        let ascender = customFont.ascender
        let descender = customFont.descender
        let lineHeight = ascender - descender
        baseline = (customFont.capHeight - lineHeight) / 2 - descender
    }
}

extension View {
    func customFont(
        name: String,
        style: NSFont.TextStyle,
        weight: Font.Weight = .regular
    ) -> some View {
        modifier(CustomFont(name: name, style: style, weight: weight))
    }
}
