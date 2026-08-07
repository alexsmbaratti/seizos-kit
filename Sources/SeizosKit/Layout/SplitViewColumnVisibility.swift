//
//  SplitViewColumnVisibility.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/4/26.
//

import SwiftUI

private struct SplitViewStackedOverrideKey: EnvironmentKey {
    static let defaultValue: Bool? = nil
}

extension EnvironmentValues {
    fileprivate var splitViewStackedOverride: Bool? {
        get { self[SplitViewStackedOverrideKey.self] }
        set { self[SplitViewStackedOverrideKey.self] = newValue }
    }
}

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
    ///
    /// `NavigationSplitView` gives each of its columns its own
    /// `horizontalSizeClass` based on that column's actual on-screen width,
    /// not the split view's overall layout — a sidebar column commonly
    /// measures `.compact` on its own even while the split view is showing
    /// sidebar and detail side by side on iPad or Mac. Reading this property
    /// from inside a column (which is exactly where something like
    /// `StackedOnlyToolbarItem` is normally used) would otherwise see that
    /// per-column override and report `true` even when the layout isn't
    /// stacked. Apply `.trackingSplitViewStacked()` to the `NavigationSplitView`
    /// itself — outside its `sidebar`/`detail` closures — to capture the
    /// un-overridden size class once and make this property reliable from
    /// anywhere inside it, including from within a column.
    public var isSplitViewStacked: Bool {
        splitViewStackedOverride ?? (horizontalSizeClass == .compact)
    }
}

/// Captures the `horizontalSizeClass` in scope where it's applied — meant to
/// be the `NavigationSplitView` itself, above its `sidebar`/`detail` closures
/// and their per-column size class overrides — and republishes it so
/// `isSplitViewStacked` reports the split view's actual stacked/side-by-side
/// state from anywhere inside it.
public struct SplitViewStackedTrackingModifier: ViewModifier {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    public func body(content: Content) -> some View {
        content.environment(
            \.splitViewStackedOverride,
            horizontalSizeClass == .compact
        )
    }
}

extension View {
    /// See ``SplitViewStackedTrackingModifier``. Apply directly to a
    /// `NavigationSplitView` so `isSplitViewStacked` — and anything built on
    /// it, like `StackedOnlyToolbarItem` — reads the split view's real
    /// stacked/side-by-side state instead of a column's locally-overridden
    /// size class.
    public func trackingSplitViewStacked() -> some View {
        modifier(SplitViewStackedTrackingModifier())
    }
}
