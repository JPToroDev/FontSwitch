//
// FocusablePanel.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import AppKit

final class FocusablePanel: NSPanel {
    // Panels without titles and resize bars can't become key (focused) by
    // default. SwiftUI's appearsActive environment value is read-only, so
    // we need to subclass NSPanel to control key window behavior manually.
    // We become key when using the search bar to receive keyboard input,
    // but otherwise stay inactive so paste operations target the app with
    // the text being formatted.
    override var canBecomeKey: Bool {
        true
    }
}
