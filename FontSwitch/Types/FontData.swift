//
// FontData.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import CoreTransferable
import UniformTypeIdentifiers

nonisolated struct FontData: Identifiable, Equatable, Hashable, Codable {
    let name: String
    let isVisible: Bool
    let collections: [String]
    var id = UUID()
}

nonisolated extension FontData: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .font)
    }
}
