//
//  MonochromeForegroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/24/26.
//

import SwiftUI

/// Applies a foreground color that resolves to pure white in dark mode and pure black in
/// light mode, independent of the app's tint/accent color.
public struct MonochromeForegroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let opacity: Double

    public init(opacity: Double = 1) {
        self.opacity = opacity
    }

    public func body(content: Content) -> some View {
        content.foregroundStyle(
            (colorScheme == .dark ? Color.white : Color.black).opacity(opacity)
        )
    }
}

extension View {
    /// Applies a foreground color that resolves to pure white in dark mode and pure black in
    /// light mode, independent of the app's tint/accent color.
    public func monochromeForegroundStyle(opacity: Double = 1) -> some View {
        modifier(MonochromeForegroundModifier(opacity: opacity))
    }
}
