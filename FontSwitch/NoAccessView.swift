//
// NoAccessView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI
import Combine

struct NoAccessView: View {
    @State private var isAnimating = true
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 20) {
            warningHeader
                .overlay(alignment: .bottom) {
                    Divider()
                }

            Text("Font Switch requires Accessibility Access to function.")
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .padding(.horizontal, 25)

            Button("System Settings...", action: openSystemPreferences)

            Spacer()
        }
        .background(.thickMaterial)
    }

    private var warningHeader: some View {
        ZStack {
            Color.warningBackground
            Stripes()
                .mask(LinearGradient(
                    gradient: Gradient(colors: [.black, .black, .clear]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing))
            warningHeaderText
        }
    }

    private var warningHeaderText: some View {
        HStack {
            Image(systemName: isAnimating ? "lock.fill" : "exclamationmark.lock.fill")
                .font(.system(size: 40))
                .fontWeight(.medium)
                .padding(.leading, -7.5)
                .contentTransition(.symbolEffect(.replace))
                .onReceive(timer) { _ in
                    withAnimation { isAnimating.toggle() }
                }

            VStack(alignment: .leading, spacing: 0) {
                Text("Permission")
                Text("Required")
            }
            .font(.title2.smallCaps())
            .fontWeight(.bold)
            .kerning(1.02)
        }
        .foregroundStyle(.white)
    }

    private func openSystemPreferences() {
        if let url = URL(string: K.accessibilitySettingsURLScheme) {
            openURL(url)
        }
    }
}

#Preview {
    NoAccessView()
        .frame(width: 200)
}
