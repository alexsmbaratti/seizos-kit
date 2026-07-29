//
//  ImageBackgroundModifier.swift
//  SeizosKit
//
//  Created by Alex Baratti on 7/28/26.
//

import SwiftUI

public struct ImageBackgroundModifier: ViewModifier {
    private let image: Image

    #if os(watchOS)
        @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    #endif

    public init(image: Image) {
        self.image = image
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
                                .frame(width: proxy.size.width, height: proxy.size.height / 2)
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
    /// - Other platforms (iOS, macOS): The image fades out from top to center, extending approximately halfway down the screen.
    ///
    /// - Parameter image: The image to use as the background.
    /// - Returns: A view with the image background applied.
    public func imageBackground(image: Image) -> some View {
        self.modifier(ImageBackgroundModifier(image: image))
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
        .imageBackground(image: Image(systemName: "mountain.2.fill"))
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
