//
// PillView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct PillView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .padding(.vertical, 2)
            .padding(.horizontal, 5)
            .background(.quinary)
            .clipShape(Capsule(style: .continuous))
    }
}

#Preview {
    PillView(text: "PDF")
}
