//
//  PlatformAdaptiveBackground.swift
//  SeizosKit
//
//  Created by Alex Baratti on 7/28/26.
//

import SwiftUI

/// Wraps `content` in a platform-adaptive background: no background on
/// visionOS, `full` on watchOS (skipped when luminance is reduced), and
/// `partial` everywhere else.
struct PlatformAdaptiveBackground<Full: View, Partial: View>: ViewModifier {
    @ViewBuilder let full: () -> Full
    @ViewBuilder let partial: () -> Partial

    #if os(watchOS)
        @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    #endif

    func body(content: Content) -> some View {
        content
            .background(
                Group {
                    #if os(visionOS)
                        // visionOS: no background
                    #elseif os(watchOS)
                        if !isLuminanceReduced {
                            full()
                        }
                    #else
                        partial()
                    #endif
                }
                .ignoresSafeArea()
            )
    }
}
