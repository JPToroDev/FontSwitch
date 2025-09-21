<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/f8fe646c-3f04-4de4-921f-6e6675bf651e">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/03485b77-0df5-4ada-805d-3854efb89481">
  <img width="250" height="250" alt="Font Switch app icon" src="https://github.com/user-attachments/assets/03485b77-0df5-4ada-805d-3854efb89481">
</picture>
</p>

<h1 align="center">Font Switch</h1>

<p align="center">
  <strong>A full-powered menu-bar app that beautifully blends SwiftUI and AppKit</strong>
</p>

<p align="center">
  <a href="https://swift.org">
	<img src="https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat" alt="Swift 6.0">
  </a>
  <a href="https://developer.apple.com/macos/">
	<img src="https://img.shields.io/badge/macOS-15.0+-blue.svg?style=flat" alt="macOS 15.0+">
  </a>
  <a href="https://opensource.org/licenses/MIT">
	<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat" alt="MIT License">
  </a>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="#-resources">Resources</a>
</p>

---

## 🛠️ Overview
**Font Switch** is a full-powered menu-bar application that pushes SwiftUI to its limits and uses AppKit to reach the finish line. While `MenuBarExtra` works great for simple cases, it doesn't handle right-click detection or draggable windows. SwiftUI's new window-management APIs are powerful, but not quite complete—for example, there's no way to programmatically set the key (focused) window.

Font Switch showcases how to build a production-ready menu-bar application using Swift 6 and the latest and greatest from SwiftUI—including the `@Observable` macro, window APIs, and `onKeyPress()` modifier. It also demonstrates [Sparkle 2.0](https://sparkle-project.org/) integration for App Store alternatives and global shortcuts via [HotKey](https://github.com/soffes/HotKey). And that's just the tip of the iceberg.

## ✨ Features

### Core Functionality
- **🎯 Global Font Switching** — Instantly change the font of text selected in any application
- **📚 Full-Fledged Font Manager** — CRUD operations for fonts and font collections
- **👁️ Font Visibility Control** — Hide unwanted fonts to declutter your font picker
- **⌨️ Keyboard Navigation** — Full keyboard support with focus rings and arrow key navigation

### Developer Highlights
- **Modern Architectures** — Swift 6, structured concurrency, and the `@Observable` macro 
- **SwiftUI + AppKit Integration** — Full-powered menu-bar app using `NSStatusItem`, `NSPanel`, and `@NSApplicationDelegateAdaptor`
- **Keyboard Shortcuts Galore** — Global shortcuts via [HotKey](https://github.com/soffes/HotKey) and view-specific commands via `onKeyPress()`
- **Custom Environment Actions** — `DismissAction`-style custom environment types
- **Sparkle Integration** — Complete app update system with beta channel support via [Sparkle](https://sparkle-project.org/)

## 📸 Screenshots

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/d7f172ab-e9d0-454e-9efc-43fbcf05474c">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/42bfeca0-fbe4-4a9e-bba3-b6906dae41d0">
  <img height="350" alt="Floating font-picker panel with programmatic focus (key state)" src="https://github.com/user-attachments/assets/42bfeca0-fbe4-4a9e-bba3-b6906dae41d0">
</picture>
   <br>
 <em>Floating font-picker panel with programmatic focus (key state)</em>
</p>

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/0c1576e8-c85a-4f8c-871a-d8d1e284be61">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/e5f4df61-ad8b-4cff-a216-eeaf07ab903c">
  <img alt="Font manager with collection browser and font visibility controls" src="https://github.com/user-attachments/assets/e5f4df61-ad8b-4cff-a216-eeaf07ab903c">
</picture>
   <br>
 <em>Font manager with collection browser and font visibility controls</em>
</p>

<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://github.com/user-attachments/assets/eae94fb3-7453-4fae-8a2f-5f9faae2978a">
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/user-attachments/assets/abd5c62e-0259-4073-81cd-ed86d6a2cfb8">
  <img alt="Settings and right-click menu" src="https://github.com/user-attachments/assets/abd5c62e-0259-4073-81cd-ed86d6a2cfb8">
</picture>
   <br>
 <em>Settings and menu-bar right-click menu</em>
</p>

## 🚀 Installation

### Requirements
- macOS 15.0 or later
- Xcode 26.0 or later
- Swift 6.0 or later

### Building from Source

Before building, set:
1. `DEVELOPMENT_TEAM` — your Apple Team ID
2. `BUNDLE_ID_PREFIX` — your reverse-domain prefix (e.g. `com.example`)

Open the project in Xcode 26 or later and run on "My Mac".

### Sparkle Setup

To set up [Sparkle](https://sparkle-project.org/), check out [Matteo Spada's exceptional implementation guide](https://medium.com/@matteospada.m/how-to-integrate-the-sparkle-framework-into-a-swiftui-app-for-macos-98ca029f83f7).

## 🏗 Architecture

Here's how Font Switch tackles some interesting macOS development challenges:

### 🍎 Menu Bar App with `NSStatusItem`
Since `MenuBarExtra` has limitations, Font Switch uses `NSStatusItem` for the menu bar integration:
- Full control over right-click detection and context menus
- `NSHostingMenu` to power AppKit menus with SwiftUI views—handy for avoiding runtime warnings when opening settings outside of a `View`

### 🪟 Floating Panels with `NSPanel`
The floating font picker uses a custom `NSPanel` implementation where standard window APIs fall short:
- `FocusablePanel` subclass handles proper focus management and position persistence across app launches
- Control whether the panel receives keyboard input (for searching) or the app with selected text receives input (for applying fonts) via the `@Environment`

### 🎨 Custom Environment Actions
Font Switch implements custom environment actions that work like `DismissAction`:
```swift
@Environment(\.focusMainWindow) private var focusMainWindow

Button("Focus Window") {
  focusMainWindow()
}
```

### 🔤 `NSFontManager` Integration
Font collection management uses `NSFontManager` for the heavy lifting:
- Create, rename, and delete collections
- Add fonts via context menu or drag-and-drop using the `Transferable` protocol
- Font visibility control with `UserDefaults` persistence
- Rich text formatting preservation when switching fonts across applications

### ⌨️ Advanced Keyboard Navigation
Keyboard navigation combines multiple techniques:
- `onKeyPress()` for view-specific commands
- `@FocusState` for managing focus across the interface
- Custom focus rings that match each view's shape for a polished feel

### 📋 Pasteboard Integration
The font switching works by manipulating the pasteboard:
- RTF formatting preservation
- Programmatic copy/paste with `CGEvent` simulation
- Original pasteboard state restoration after operations

## 📚 Resources

- [SwiftUI Mac Windows](https://nilcoalescing.com/blog/FullyCustomAboutWindowForAMacAppInSwiftUI/) — Overview of new window APIs
- [`NSFontManager` Idiosyncrasies](https://stackoverflow.com/questions/31971169/is-there-are-non-deprecated-way-to-access-font-collections-for-os-x-10-11) — API tips and tricks
- [Making `NSPanel` Keyable](https://stackoverflow.com/questions/75736964/how-can-i-make-my-borderless-window-be-the-key-window-after-launch) — Making a utility window keyable (focusable)
- [Sparkle 2.0](https://medium.com/@matteospada.m/how-to-integrate-the-sparkle-framework-into-a-swiftui-app-for-macos-98ca029f83f7) — Exceptional tutorial from Matteo Spada
- [Requesting Accessibility Access](https://stackoverflow.com/questions/52214771/accessibility-permissions-for-development-in-macos-and-xcode) — How to interact with other apps

## 📄 License

Font Switch is available under the MIT License. See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [HotKey](https://github.com/soffes/HotKey) — Global shortcut framework
- [Sparkle](https://sparkle-project.org/) — App update framework
- App icon by Rudra Das

<!-- SEO Keywords: SwiftUI menu bar app, Swift 6 @Observable macro, NSStatusItem NSPanel, global shortcuts HotKey, NSFontManager font collections, keyboard navigation focus rings, AppKit SwiftUI integration, Sparkle app updates, custom environment actions, macOS 15 development, floating panel NSPanel, accessibility permissions, pasteboard RTF manipulation, font management macOS, approachable concurrency, structured concurrency, strict concurrency -->
