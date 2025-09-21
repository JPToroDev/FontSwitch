//
// FontManagerView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct FontManagerView: View {
    @State private var selectedCollection = "All Fonts"

    var body: some View {
        HStack(spacing: 25) {
            CollectionBrowser(selectedCollection: $selectedCollection)
                .frame(width: 200)
            FontBrowser(selectedCollection: $selectedCollection)
                .frame(width: 400)
        }
        .scenePadding()
    }
}

#Preview {
    FontManagerView()
}
