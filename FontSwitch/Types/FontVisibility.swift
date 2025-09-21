//
// FontVisibility.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import Foundation

enum FontVisibility: String, CaseIterable {
    case all
    case visible
    case hidden

    var description: String {
        String(describing: self).capitalized
    }
}
