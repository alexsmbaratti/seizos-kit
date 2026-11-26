//
//  SplitViewColumnVisibility.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/4/26.
//

import SwiftUI

extension EnvironmentValues {
    /// Whether a `NavigationSplitView` in the current context is showing its
    /// columns one at a time in a single stack, rather than side by side.
    ///
    /// Mirrors the size class `NavigationSplitView` itself keys off of to decide
    /// between a stacked and a side-by-side layout. Use it to avoid duplicating a
    /// toolbar item across two columns that can both be visible at once — e.g. a
    /// sidebar's own copy of an action a simultaneously-visible detail column
    /// already shows. Compact width covers not just a portrait iPhone but also
    /// Slide Over and other narrow multitasking contexts; regular width covers
    /// iPad, Mac, Vision, and iOS 27's iPad-style landscape layout for iPhone.
    public var isSplitViewStacked: Bool {
        horizontalSizeClass == .compact
    }
}

extension EnvironmentValues {
    /// Whether the sidebar column of the enclosing `NavigationSplitView` is
    /// currently on screen next to the detail column.
    ///
    /// `NavigationSplitView` doesn't expose this to its content, so the host sets
    /// it from its own `NavigationSplitViewVisibility` binding with
    /// ``SwiftUI/View/splitViewSidebarVisible(_:)``. Defaults to `false`, so
    /// components that hide themselves while the sidebar is visible stay
    /// available if the host never wires this up.
    @Entry public var isSplitViewSidebarVisible = false
}

extension View {
    /// Publishes whether the split view's sidebar is on screen to descendants via
    /// ``SwiftUI/EnvironmentValues/isSplitViewSidebarVisible``.
    ///
    ///     NavigationSplitView(columnVisibility: $columnVisibility) { ... }
    ///         .splitViewSidebarVisible(columnVisibility != .detailOnly)
    public func splitViewSidebarVisible(_ isVisible: Bool) -> some View {
        environment(\.isSplitViewSidebarVisible, isVisible)
    }
}
