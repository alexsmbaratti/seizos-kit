//
//  GradientBackgroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/22/25.
//

import SwiftUI

public struct GradientBackgroundModifier: ViewModifier {
    private let color: Color

    @Environment(\.colorScheme) private var colorScheme
    #if os(watchOS)
        @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    #endif

    public init(color: Color) {
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .background(
                Group {
                    #if os(visionOS)
                        // visionOS: no gradient
                    #elseif os(watchOS)
                        if !isLuminanceReduced {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.5),
                                    color.opacity(0.2),
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        }
                    #else
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(colorScheme == .light ? 1 : 0.5),
                                Color.clear,
                            ]),
                            startPoint: .top,
                            endPoint: .center
                        )
                    #endif
                }
                .ignoresSafeArea()
            )
    }
}

extension View {
    /// Applies a platform-adaptive accent gradient background to the view.
    ///
    /// Platform behavior:
    /// - watchOS: The gradient fills the entire screen.
    /// - visionOS: No gradient is applied, to better match visionOS aesthetics.
    /// - Other platforms (iOS, macOS): The gradient extends approximately halfway down the screen.
    ///
    /// - Parameter color: The base color of the gradient.
    /// - Returns: A view with the accent gradient background applied.
    public func gradientBackground(color: Color) -> some View {
        self.modifier(GradientBackgroundModifier(color: color))
    }
}

#Preview("Simple View") {
    NavigationStack {
        ScrollView {
            Group {
                LeadingHeading("This is a test of the gradient background.")
            }
            .padding([.leading, .bottom, .trailing])
        }
        .navigationTitle("Hello, world!")
        .toolbar {
            ToolbarItem(
                placement: {
                    #if os(macOS)
                    .automatic
                    #else
                    .topBarTrailing
                    #endif
                }(),
                content: {
                    Button(
                        action: {},
                        label: {
                            Label("Test", systemImage: "star")
                        }
                    )
                }
            )
        }
        .gradientBackground(color: .red)
    }
}

#Preview("NavigationSplitView") {
    NavigationSplitView(
        sidebar: {
            Text(
                "This preview is intended for devices that display both the sidebar and detail views of a NavigationSplitView. If only this view is displayed, ignore this preview for this device."
            )
        },
        detail: {
            ScrollView {
                Group {
                    LeadingHeading("This is a test of the gradient background.")
                }
                .padding([.leading, .bottom, .trailing])
            }
            .navigationTitle("Hello, world!")
            .toolbar {
                ToolbarItem(
                    placement: {
                        #if os(macOS)
                        .automatic
                        #else
                        .topBarTrailing
                        #endif
                    }(),
                    content: {
                        Button(
                            action: {},
                            label: {
                                Label("Test", systemImage: "star")
                            }
                        )
                    }
                )
            }
            .gradientBackground(color: .red)
        }
    )
}
