//
//  GradientBackgroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/22/25.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public struct GradientBackgroundModifier: ViewModifier {
    private let color: Color
    private let heightFraction: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    public init(color: Color, heightFraction: CGFloat = 0.5) {
        self.color = color
        self.heightFraction = heightFraction
    }

    public init(
        image: CGImage,
        strategy: ImageColorExtractionStrategy,
        heightFraction: CGFloat = 0.5
    ) {
        self.color = image.representativeColor(using: strategy)
        self.heightFraction = heightFraction
    }

    #if canImport(UIKit)
        public init(
            image: UIImage,
            strategy: ImageColorExtractionStrategy,
            heightFraction: CGFloat = 0.5
        ) {
            if let cgImage = image.cgImage {
                self.init(image: cgImage, strategy: strategy, heightFraction: heightFraction)
            } else {
                self.init(color: .gray, heightFraction: heightFraction)
            }
        }
    #elseif canImport(AppKit)
        public init(
            image: NSImage,
            strategy: ImageColorExtractionStrategy,
            heightFraction: CGFloat = 0.5
        ) {
            if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                self.init(image: cgImage, strategy: strategy, heightFraction: heightFraction)
            } else {
                self.init(color: .gray, heightFraction: heightFraction)
            }
        }
    #endif

    public func body(content: Content) -> some View {
        content.modifier(
            PlatformAdaptiveBackground(
                full: {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.5),
                            color.opacity(0.2),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                },
                partial: {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(colorScheme == .light ? 1 : 0.5),
                            Color.clear,
                        ]),
                        startPoint: .top,
                        endPoint: UnitPoint(x: 0.5, y: heightFraction)
                    )
                }
            )
        )
    }
}

extension View {
    /// Applies a platform-adaptive accent gradient background to the view.
    ///
    /// Platform behavior:
    /// - watchOS: The gradient fills the entire screen.
    /// - visionOS: No gradient is applied, to better match visionOS aesthetics.
    /// - Other platforms (iOS, macOS): The gradient extends down from the top and fades to clear by `heightFraction` of the view's height.
    ///
    /// - Parameters:
    ///   - color: The base color of the gradient.
    ///   - heightFraction: The fraction of the view's height the gradient fades out over, from `0` (top) to `1` (bottom). Defaults to `0.5`. Ignored on watchOS and visionOS.
    /// - Returns: A view with the accent gradient background applied.
    public func gradientBackground(color: Color, heightFraction: CGFloat = 0.5)
        -> some View
    {
        self.modifier(
            GradientBackgroundModifier(
                color: color,
                heightFraction: heightFraction
            )
        )
    }

    /// Applies a platform-adaptive accent gradient background derived from an image's color.
    ///
    /// The gradient color is computed once, up front, from `image` using `strategy` — see
    /// ``gradientBackground(color:heightFraction:)`` for the gradient's platform behavior.
    ///
    /// - Parameters:
    ///   - image: The image to derive the gradient's base color from.
    ///   - strategy: How to derive a single color from `image`.
    ///   - heightFraction: The fraction of the view's height the gradient fades out over, from `0` (top) to `1` (bottom). Defaults to `0.5`. Ignored on watchOS and visionOS.
    /// - Returns: A view with the accent gradient background applied.
    public func gradientBackground(
        image: CGImage,
        strategy: ImageColorExtractionStrategy,
        heightFraction: CGFloat = 0.5
    ) -> some View {
        self.modifier(
            GradientBackgroundModifier(
                image: image,
                strategy: strategy,
                heightFraction: heightFraction
            )
        )
    }

    #if canImport(UIKit)
        /// Applies a platform-adaptive accent gradient background derived from an image's color.
        ///
        /// See ``gradientBackground(image:strategy:heightFraction:)``.
        public func gradientBackground(
            image: UIImage,
            strategy: ImageColorExtractionStrategy,
            heightFraction: CGFloat = 0.5
        ) -> some View {
            self.modifier(
                GradientBackgroundModifier(
                    image: image,
                    strategy: strategy,
                    heightFraction: heightFraction
                )
            )
        }
    #elseif canImport(AppKit)
        /// Applies a platform-adaptive accent gradient background derived from an image's color.
        ///
        /// See ``gradientBackground(image:strategy:heightFraction:)``.
        public func gradientBackground(
            image: NSImage,
            strategy: ImageColorExtractionStrategy,
            heightFraction: CGFloat = 0.5
        ) -> some View {
            self.modifier(
                GradientBackgroundModifier(
                    image: image,
                    strategy: strategy,
                    heightFraction: heightFraction
                )
            )
        }
    #endif
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
        .gradientBackground(color: .red, heightFraction: 0.5)
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
