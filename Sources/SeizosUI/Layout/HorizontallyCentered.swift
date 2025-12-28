//
//  HorizontallyCentered.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct HorizontallyCentered: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

public extension View {
    func horizontallyCentered() -> some View {
        modifier(HorizontallyCentered())
    }
}
