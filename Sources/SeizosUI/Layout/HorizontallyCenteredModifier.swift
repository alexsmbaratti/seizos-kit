//
//  HorizontallyCentered.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct HorizontallyCenteredModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

extension View {
    public func horizontallyCentered() -> some View {
        modifier(HorizontallyCenteredModifier())
    }
}
