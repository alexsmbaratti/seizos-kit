//
//  VerticallyCentered.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct VerticallyCentered: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxHeight: .infinity, alignment: .center)
    }
}

public extension View {
    func verticallyCentered() -> some View {
        modifier(VerticallyCentered())
    }
}
