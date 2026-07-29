//
//  ImageBackgroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 7/28/26.
//

import SwiftUI

public struct ImageBackgroundModifier: ViewModifier {
    private let image: Image
    private let heightFraction: CGFloat

    #if os(watchOS)
        @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    #endif

    public init(image: Image, heightFraction: CGFloat = 0.5) {
        self.image = image
        self.heightFraction = heightFraction
    }

    public func body(content: Content) -> some View {
        content
            .background(
                Group {
                    #if os(visionOS)
                        // visionOS: no image background
                    #elseif os(watchOS)
                        if !isLuminanceReduced {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    #else
                        GeometryReader { proxy in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: proxy.size.width,
                                    height: proxy.size.height * heightFraction
                                )
                                .clipped()
                                .mask(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .white, .white, .clear,
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    #endif
                }
                .ignoresSafeArea()
            )
    }
}

extension View {
    /// Applies a platform-adaptive image background to the view.
    ///
    /// Platform behavior:
    /// - watchOS: The image fills the entire screen.
    /// - visionOS: No image is applied, to better match visionOS aesthetics.
    /// - Other platforms (iOS, macOS): The image occupies the top `heightFraction` of the view and fades out at its trailing edge.
    ///
    /// - Parameters:
    ///   - image: The image to use as the background.
    ///   - heightFraction: The fraction of the view's height the image occupies, from `0` to `1`. Defaults to `0.5`. Ignored on watchOS and visionOS.
    /// - Returns: A view with the image background applied.
    public func imageBackground(image: Image, heightFraction: CGFloat = 0.5)
        -> some View
    {
        self.modifier(
            ImageBackgroundModifier(
                image: image,
                heightFraction: heightFraction
            )
        )
    }
}

#Preview("Simple View") {
    NavigationStack {
        ScrollView {
            Group {
                LeadingHeading("This is a test of the image background.")
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
        .imageBackground(
            image: Image(systemName: "mountain.2.fill"),
            heightFraction: 0.5
        )
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
                    LeadingHeading("This is a test of the image background.")
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
            .imageBackground(image: Image(systemName: "mountain.2.fill"))
        }
    )
}
