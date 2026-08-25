//
//  MonochromeForegroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/24/26.
//

import SwiftUI

/// The emphasis of a `monochromeForegroundStyle` color, mirroring the primary/secondary
/// distinction of `ShapeStyle.primary`/`ShapeStyle.secondary`.
public enum MonochromeForegroundEmphasis {
    case primary
    case secondary

    fileprivate var opacity: Double {
        switch self {
        case .primary: 1
        case .secondary: 0.6
        }
    }
}

public struct MonochromeForegroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let emphasis: MonochromeForegroundEmphasis

    public init(emphasis: MonochromeForegroundEmphasis = .primary) {
        self.emphasis = emphasis
    }

    public func body(content: Content) -> some View {
        content.foregroundStyle(
            (colorScheme == .dark ? Color.white : Color.black).opacity(emphasis.opacity)
        )
    }
}

extension View {
    /// Applies a foreground color that resolves to pure white in dark mode and pure black in
    /// light mode, independent of the app's tint/accent color.
    public func monochromeForegroundStyle(
        _ emphasis: MonochromeForegroundEmphasis = .primary
    ) -> some View {
        modifier(MonochromeForegroundModifier(emphasis: emphasis))
    }
}
