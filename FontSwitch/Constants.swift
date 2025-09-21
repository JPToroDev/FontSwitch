//
// Constants.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import Foundation

enum K { // swiftlint:disable:this type_name
    static let fontManagerWindowID = "font-manager"

    static let accessibilitySettingsURLScheme = """
    x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility
    """

    static let keyboardSettingsURLScheme = """
    x-apple.systempreferences:com.apple.Keyboard-Settings.extension
    """

    enum Default {
        static let selectedCollection = "selectedCollection"
        static let subscribedToBetaUpdates = "subscribedToBetaUpdates"
        static let automaticallyChecksForUpdates = "automaticallyChecksForUpdates"
        static let appHasPreviouslyLaunched = "appHasPreviouslyLaunched"
        static let hiddenFonts = "hiddenFonts"
        static let subscribedToNewsletter = "subscribedToNewsletter"

        static let panelOriginX = "panelOriginX"
        static let panelOriginY = "panelOriginY"
    }

    static let specialFonts: Set<String> = [
        "Bodoni Ornaments",
        "Webdings",
        "Wingdings",
        "Wingdings 2",
        "Wingdings 3",
        "Zapf Dingbats",
        "Zapfino"]

    static var preHiddenFonts: Set<String> {
        let regularFonts: Set<String> = [
            "Academy Engraved LET",
            "Al Bayan",
            "Al Nile",
            "Al Tarikh",
            "American Typewriter",
            "Apple Braille",
            "Apple Chancery",
            "Apple Color Emoji",
            "Apple SD Gothic Neo",
            "Apple Symbols",
            "AppleGothic",
            "AppleMyungjo",
            "Arial Black",
            "Arial Hebrew",
            "Arial Hebrew Scholar",
            "Arial Narrow",
            "Arial Rounded MT Bold",
            "Arial Unicode MS",
            "Ayuthaya",
            "Baghdad",
            "Bangla MN",
            "Bangla Sangam MN",
            "Beirut",
            "Bradley Hand",
            "Brush Script MT",
            "Chalkboard",
            "Chalkboard SE",
            "Chalkduster",
            "Comic Sans MS",
            "Copperplate",
            "Corsiva Hebrew",
            "DIN Alternate",
            "DIN Condensed",
            "Damascus",
            "DecoType Naskh",
            "Devanagari MT",
            "Devanagari Sangam MN",
            "Diwan Kufi",
            "Diwan Thuluth",
            "Euphemia UCAS",
            "Farah",
            "Farisi",
            "GB18030 Bitmap",
            "Galvji",
            "Geeza Pro",
            "Geneva",
            "Grantha Sangam MN",
            "Gujarati MT",
            "Gujarati Sangam MN",
            "Gurmukhi MN",
            "Gurmukhi MT",
            "Gurmukhi Sangam MN",
            "Heiti SC",
            "Heiti TC",
            "Herculanum",
            "Hiragino Maru Gothic ProN",
            "Hiragino Mincho ProN",
            "Hiragino Sans",
            "Hiragino Sans GB",
            "ITF Devanagari",
            "ITF Devanagari Marathi",
            "Impact",
            "InaiMathi",
            "Kailasa",
            "Kannada MN",
            "Kannada Sangam MN",
            "Kefa",
            "Khmer MN",
            "Khmer Sangam MN",
            "Kohinoor Bangla",
            "Kohinoor Devanagari",
            "Kohinoor Gujarati",
            "Kohinoor Telugu",
            "Kokonor",
            "Krungthep",
            "KufiStandardGK",
            "Lao MN",
            "Lao Sangam MN",
            "Luminari",
            "Malayalam MN",
            "Malayalam Sangam MN",
            "Marker Felt",
            "Microsoft Sans Serif",
            "Mishafi",
            "Mishafi Gold",
            "Monaco",
            "Mshtakan",
            "Mukta Mahee",
            "Muna",
            "Myanmar MN",
            "Myanmar Sangam MN",
            "Nadeem",
            "New Peninim MT",
            "Noteworthy",
            "Noto Nastaliq Urdu",
            "Noto Sans Batak",
            "Noto Sans Kannada",
            "Noto Sans Myanmar",
            "Noto Sans NKo",
            "Noto Sans Oriya",
            "Noto Sans Tagalog",
            "Noto Serif Myanmar",
            "Oriya MN",
            "Oriya Sangam MN",
            "Papyrus",
            "Party LET",
            "PingFang HK",
            "PingFang SC",
            "PingFang TC",
            "Plantagenet Cherokee",
            "Raanana",
            "STIX Two Math",
            "STIX Two Text",
            "STIXGeneral",
            "STSong",
            "Sana",
            "Sathu",
            "Savoye LET",
            "Shree Devanagari 714",
            "SignPainter",
            "Silom",
            "Sinhala MN",
            "Sinhala Sangam MN",
            "Snell Roundhand",
            "Songti SC",
            "Songti TC",
            "Sukhumvit Set",
            "Symbol",
            "Tahoma",
            "Tamil MN",
            "Tamil Sangam MN",
            "Telugu MN",
            "Telugu Sangam MN",
            "Thonburi",
            "Trattatello",
            "Trebuchet MS",
            "Verdana",
            "Waseem"]

        let allHiddenFonts = regularFonts.union(specialFonts)
        return allHiddenFonts
    }
}
