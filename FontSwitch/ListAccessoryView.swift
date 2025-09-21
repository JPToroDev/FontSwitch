//
// ListAccessoryView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct ListAccessoryView<Header: View, Content: View, Footer: View>: View {
    private var content: () -> Content
    private var header: () -> Header
    private var footer: (() -> Footer)?

    private let cornerRadius = 12.0
    private let horizontalHeaderFooterPadding = 15.0

    init(
        content: @escaping () -> Content,
        header: @escaping () -> Header,
        footer: @escaping () -> Footer
    ) {
        self.content = content
        self.header = header
        self.footer = footer
    }

    init(
        content: @escaping () -> Content,
        header: @escaping () -> Header
    ) where Footer == EmptyView {
        self.content = content
        self.header = header
        self.footer = nil
    }

    var body: some View {
        content()
            .background(.quinary, in: AnyShape(backgroundShape))
            .scrollContentBackground(.hidden)
            .listStyle(.inset)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    header()
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                        .padding(.horizontal, horizontalHeaderFooterPadding)
                        .frame(height: 28)
                    Divider()
                }
                .background(
                    .ultraThinMaterial,
                    in: .rect(
                        topLeadingRadius: cornerRadius,
                        topTrailingRadius: cornerRadius,
                        style: .continuous))
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if let footer {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                        footer()
                            .padding(.horizontal, horizontalHeaderFooterPadding)
                            .frame(height: 25)
                    }
                    .background(
                        .ultraThinMaterial,
                        in: .rect(
                            bottomLeadingRadius: cornerRadius,
                            bottomTrailingRadius: cornerRadius,
                            style: .continuous))
                }
            }
    }

    private var backgroundShape: any InsettableShape {
        if footer == nil {
            .rect(
                bottomLeadingRadius: cornerRadius,
                bottomTrailingRadius: cornerRadius,
                style: .continuous)
        } else {
            .rect
        }
    }
}
