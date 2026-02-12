//
//  File.swift
//  SeizosKit
//
//  Created by Alex Baratti on 2/11/26.
//

import SwiftUI

public struct DebugBorderModifier: ViewModifier {
    var color: Color = .red
    var lineWidth: CGFloat = 1

    public func body(content: Content) -> some View {
        #if DEBUG
            content
                .overlay(Rectangle().stroke(color, lineWidth: lineWidth))
        #else
            content
        #endif
    }
}

extension View {
    /// Applies a rectangular border around the view to assist with debugging.
    ///
    /// - Note:
    /// This modifier has no effect for non-debug builds.
    ///
    /// - Parameter color: The color of the border.
    /// - Parameter width: The width of the border.
    /// - Returns: A view with the border applied.
    public func debugBorder(color: Color = .red, lineWidth: CGFloat = 1)
        -> some View
    {
        modifier(DebugBorderModifier(color: color, lineWidth: lineWidth))
    }
}
