//
//  PinnedToTopModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct PinnedToTopModifier: ViewModifier {
    public func body(content: Content) -> some View {
        VStack {
            content
            Spacer()
        }
    }
}

extension View {
    public func pinnedToTop() -> some View {
        modifier(PinnedToTopModifier())
    }
}
