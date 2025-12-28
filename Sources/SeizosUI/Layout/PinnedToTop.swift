//
//  PinnedToTop.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct PinnedToTop: ViewModifier {
    public func body(content: Content) -> some View {
        VStack {
            content
            Spacer()
        }
    }
}

public extension View {
    func pinnedToTop() -> some View {
        modifier(PinnedToTop())
    }
}

