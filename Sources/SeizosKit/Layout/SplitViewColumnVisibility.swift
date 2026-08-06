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
