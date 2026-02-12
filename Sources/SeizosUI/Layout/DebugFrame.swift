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
    public func debugBorder(color: Color = .red, lineWidth: CGFloat = 1)
        -> some View
    {
        modifier(DebugBorderModifier(color: color, lineWidth: lineWidth))
    }
}
