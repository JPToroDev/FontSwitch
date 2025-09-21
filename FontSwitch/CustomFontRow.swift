//
// CustomFontRow.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct CustomFontRow: View {
    var fontName: String

    var body: some View {
        Text(fontName)
            .customFont(name: fontName, style: .body)
            .lineLimit(1)
    }
}

#Preview {
    CustomFontRow(fontName: "Helvetica")
}
