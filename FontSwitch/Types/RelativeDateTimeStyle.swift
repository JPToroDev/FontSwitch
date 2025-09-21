//
// RelativeDateTimeStyle.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import Foundation

struct RelativeDateTimeStyle: FormatStyle {
    typealias FormatInput = Date
    typealias FormatOutput = String

    func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: value)
    }
}

extension FormatStyle where Self == RelativeDateTimeStyle {
    static var relativeDateTime: RelativeDateTimeStyle {
        RelativeDateTimeStyle()
    }
}
