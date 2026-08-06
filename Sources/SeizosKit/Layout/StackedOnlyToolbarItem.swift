//
//  StackedOnlyToolbarItem.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/4/26.
//

import SwiftUI

/// A `ToolbarItem` that only renders while `isSplitViewStacked` is true — a
/// drop-in replacement for `ToolbarItem` at a call site that would otherwise
/// duplicate an action a simultaneously-visible sibling column already shows.
///
///     ToolbarItemGroup(placement: .topBarTrailing) {
///         StackedOnlyToolbarItem {
///             Button("Quick Reference", systemImage: "book") { ... }
///         }
///     }
public struct StackedOnlyToolbarItem<Content: View>: ToolbarContent {
    @Environment(\.isSplitViewStacked) private var isSplitViewStacked

    let placement: ToolbarItemPlacement
    let content: Content

    public init(
        placement: ToolbarItemPlacement = .automatic,
        @ViewBuilder content: () -> Content
    ) {
        self.placement = placement
        self.content = content()
    }

    @ToolbarContentBuilder
    public var body: some ToolbarContent {
        if isSplitViewStacked {
            ToolbarItem(placement: placement) {
                content
            }
        }
    }
}
