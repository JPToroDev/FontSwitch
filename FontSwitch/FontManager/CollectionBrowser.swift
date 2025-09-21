//
// CollectionBrowser.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct CollectionBrowser: View {
    @Binding var selectedCollection: String
    @Environment(TypefaceManager.self) private var typefaceManager

    @State private var hoveredCollection: String?
    @State private var collectionName = ""
    @State private var isShowingCreateAlert = false
    @State private var collectionToRename = ""
    @State private var isShowingRenameAlert = false
    @State private var collectionToDelete = ""
    @State private var isConfirmingDeletion = false

    var body: some View {
        ListAccessoryView {
            List(selection: $selectedCollection) {
                Text("All Fonts")
                    .id("All Fonts")

                ForEach(typefaceManager.collections, id: \.self) { collection in
                    Text(collection)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(.rect)
                        .listRowSeparator(.hidden)
                        .listRowBackground(listRowBackground(for: collection))
                        .contextMenu {
                            Button("Rename") {
                                presentRenameAlert(for: collection)
                            }
                            Button("Delete", role: .destructive) {
                                presentDeleteDialog(for: collection)
                            }
                        }
                        .dropDestination(for: FontData.self) { items, _ in
                            typefaceManager.add(items, to: collection)
                            hoveredCollection = nil
                            return true
                        } isTargeted: { isTarget in
                            hoveredCollection = isTarget ? collection : nil
                        }
                }
            }
        } header: {
            Text("Collections")
        } footer: {
            footer
        }
        .alert("Create Collection", isPresented: $isShowingCreateAlert) {
            TextField("Name", text: $collectionName)
            Button("Create", action: createCollection)
            cancelButton
        }
        .alert("Rename Collection", isPresented: $isShowingRenameAlert) {
            TextField("Name", text: $collectionName)
            Button("Rename", action: renameCollection)
            cancelButton
        }
        .confirmationDialog("Are you sure?", isPresented: $isConfirmingDeletion) {
            Button("Delete", role: .destructive, action: deleteCollection)
            cancelButton
        }
    }

    private func listRowBackground(for collection: String) -> some View {
        Rectangle()
            .fill(Color.accentColor.tertiary)
            .clipShape(.rect(cornerRadius: 8, style: .continuous))
            .opacity(hoveredCollection == collection && selectedCollection != collection ? 1.0 : 0.0)
            .padding(.horizontal, 10)
    }

    private var footer: some View {
        HStack(spacing: 5) {
            Spacer()
            Button("Add Collection", systemImage: "plus") {
                isShowingCreateAlert = true
            }

            Divider()
                .frame(height: 15)

            Button("Remove Collection", systemImage: "minus") {
                if selectedCollection != "All Fonts" {
                    presentDeleteDialog(for: selectedCollection)
                }
            }
        }
        .buttonStyle(.borderless)
        .labelStyle(.iconOnly)
        .imageScale(.small)
        .fontWeight(.medium)
    }

    private var cancelButton: some View {
        Button("Cancel", role: .cancel) {}
    }

    private func presentRenameAlert(for collection: String) {
        collectionToRename = collection
        isShowingRenameAlert = true
    }

    private func presentDeleteDialog(for collection: String) {
        collectionToDelete = collection
        isConfirmingDeletion = true
    }

    private func createCollection() {
        typefaceManager.createCollection(named: collectionName)
        typefaceManager.getFontCollections()
        collectionName = ""
    }

    private func renameCollection() {
        typefaceManager.renameCollection(from: collectionToRename, to: collectionName)
        typefaceManager.getFontCollections()
        collectionName = ""
    }

    private func deleteCollection() {
        typefaceManager.deleteCollection(named: collectionToDelete)
    }
}
