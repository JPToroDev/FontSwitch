//
// Stripes.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct Stripes: View {
    var background: Color = .warningBackground
    var foreground: Color = .warningForeground
    var degrees: Double = 45
    var barWidth: CGFloat = 3
    var barSpacing: CGFloat = 3

    var body: some View {
        GeometryReader { geometry in
            let longSide = max(geometry.size.width, geometry.size.height)
            let itemWidth = barWidth + barSpacing
            let items = Int(2 * longSide / itemWidth)

            HStack(spacing: barSpacing) {
                ForEach(0..<items, id: \.self) { _ in
                    foreground
                        .frame(width: barWidth, height: 2 * longSide)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .rotationEffect(Angle(degrees: degrees), anchor: .center)
            .offset(x: -longSide / 2, y: -longSide / 2)
            .background(background)
        }
        .clipped()
    }
}

#Preview {
    Stripes()
}
