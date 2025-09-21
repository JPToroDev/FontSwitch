//
// AppDelegate.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import AppKit
import SwiftUI
import HotKey

class AppDelegate: NSObject {
    fileprivate static var shared: AppDelegate!
    private let panelShortcut = HotKey(key: .f, modifiers: [.control])

    let typefaceManager = TypefaceManager()
    let permissionManager = PermissionManager()
    let updateManager = UpdateManager()

    private var menuBarItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let image = NSImage(systemSymbolName: "textformat", accessibilityDescription: "Font Switch Menu")
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.action = #selector(menuButtonClicked)
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        return statusItem
    }()

    fileprivate lazy var panel: NSPanel = {
        let panel = FocusablePanel()
        panel.level = .floating
        panel.collectionBehavior.insert(.fullScreenAuxiliary)
        panel.titlebarAppearsTransparent = true
        panel.hidesOnDeactivate = false
        panel.styleMask = [.nonactivatingPanel, .resizable]
        panel.titleVisibility = .hidden
        panel.acceptsMouseMovedEvents = true
        panel.animationBehavior = .utilityWindow
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.becomesKeyOnlyIfNeeded = true
        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true

        let contentView = ContentView()
            .environment(typefaceManager)
            .environment(permissionManager)
            .environment(updateManager)

        panel.contentViewController = NSHostingController(rootView: contentView)
        return panel
    }()

    private func hidePreHiddenFonts() {
        let hasAlreadyLaunched = UserDefaults.standard.bool(forKey: K.Default.appHasPreviouslyLaunched)
        guard !hasAlreadyLaunched else { return }
        typefaceManager.hidePreHiddenFonts()
        UserDefaults.standard.set(true, forKey: K.Default.appHasPreviouslyLaunched)
    }

    private func setupPanelTogglingShortcut() {
        panelShortcut.keyUpHandler = { [weak self] in
            self?.togglePanelVisibility()
        }
    }

    private func positionPanelAtCenter() {
        guard let screen = NSScreen.main else {
            print("Failed to find the main screen.")
            return
        }

        let screenFrame = screen.visibleFrame
        let panelSize = CGSize(width: 200, height: 250)

        let frame = CGRect(
            x: screenFrame.midX - panelSize.width / 2,
            y: screenFrame.midY - panelSize.height / 2,
            width: panelSize.width,
            height: panelSize.height)

        panel.setFrame(frame, display: true)
        panel.orderFrontRegardless()
        panel.makeKey()
    }

    private func savePanelPosition() {
        let frame = panel.frame
        UserDefaults.standard.set(frame.origin.x, forKey: K.Default.panelOriginX)
        UserDefaults.standard.set(frame.origin.y, forKey: K.Default.panelOriginY)
    }

    private func restorePanelPosition() {
        let savedX = UserDefaults.standard.double(forKey: K.Default.panelOriginX)
        let savedY = UserDefaults.standard.double(forKey: K.Default.panelOriginY)

        // Check if we have a valid saved position and it's still on screen
        if savedX != 0.0 || savedY != 0.0, let screen = NSScreen.main {
            let panelSize = CGSize(width: 200, height: 250)
            let frame = CGRect(x: savedX, y: savedY, width: panelSize.width, height: panelSize.height)

            if screen.visibleFrame.contains(frame.origin) {
                panel.setFrame(frame, display: true)
                panel.orderFrontRegardless()
                panel.makeKey()
                return
            }
        }

        positionPanelAtCenter()
    }

    @objc private func menuButtonClicked() {
        if let event = NSApp.currentEvent, event.type == .rightMouseUp || NSEvent.modifierFlags.contains(.control) {
            let menu = NSHostingMenu(rootView: Group {
               RightClickMenu()
                    .environment(updateManager)
            })
            menuBarItem.menu = menu
            menuBarItem.button?.performClick(nil)
        } else {
            togglePanelVisibility()
        }
    }

    private func togglePanelVisibility() {
        if panel.isVisible {
            savePanelPosition()
            panel.close()
        } else {
            restorePanelPosition()
        }
    }
}

extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AppDelegate.shared = self
        hidePreHiddenFonts()
        setupPanelTogglingShortcut()
        restorePanelPosition()
        PermissionManager.requestAccessibilityPrivileges()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}

// Custom environment actions that mirror DismissAction's
// callAsFunction() pattern, giving us clean APIs without unnecessarily
// exposing AppDelegate's implementation details.

struct FocusMainWindowAction {
    func callAsFunction() {
        AppDelegate.shared.panel.makeKey()
    }
}

struct UnfocusMainWindowAction {
    func callAsFunction() {
        AppDelegate.shared.panel.resignKey()
    }
}

extension EnvironmentValues {
    @Entry var focusMainWindow = FocusMainWindowAction()
    @Entry var unfocusMainWindow = UnfocusMainWindowAction()
}
