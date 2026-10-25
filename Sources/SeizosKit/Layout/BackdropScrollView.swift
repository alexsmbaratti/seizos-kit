//
//  BackdropScrollView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 10/18/26.
//

import SwiftUI

/// A scroll view that shows a fixed backdrop behind its content, with the content offset so the
/// backdrop is visible above it.
///
/// The backdrop stays in place while the content scrolls up over it. The top of the content
/// dissolves the backdrop into the background, then stays opaque so scrolled content fully
/// covers it. The backdrop extends under the navigation bar.
///
/// Use ``MapBackdropScrollView`` for a map backdrop.
public struct BackdropScrollView<Backdrop: View, Content: View>: View {
    private let backdropHeight: CGFloat
    private let overlap: CGFloat
    private let fadeHeight: CGFloat
    private let fallbackTopPadding: CGFloat
    private let backdrop: Backdrop?
    private let content: Content

    /// - Parameters:
    ///   - backdropHeight: The height of the backdrop. Ignored when `backdrop` is `nil`.
    ///   - overlap: How far the content overlaps the bottom of the backdrop. Defaults to `120`.
    ///   - fadeHeight: The height of the dissolve between the backdrop and the content. Defaults to `160`.
    ///   - fallbackTopPadding: The padding above the content when `backdrop` is `nil`. Defaults to `80`.
    ///   - backdrop: The backdrop to display. Pass `nil` to show only the content.
    ///   - content: The scrolling content.
    public init(
        backdropHeight: CGFloat,
        overlap: CGFloat = 120,
        fadeHeight: CGFloat = 160,
        fallbackTopPadding: CGFloat = 80,
        backdrop: Backdrop?,
        @ViewBuilder content: () -> Content
    ) {
        self.backdropHeight = backdropHeight
        self.overlap = overlap
        self.fadeHeight = fadeHeight
        self.fallbackTopPadding = fallbackTopPadding
        self.backdrop = backdrop
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
                // Dissolves the backdrop into the background, then stays opaque so
                // content scrolling up covers the fixed backdrop.
                .background(alignment: .top) {
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle().fill(.ultraThinMaterial)
                            Rectangle().fill(.background)
                        }
                        .mask(
                            LinearGradient(
                                colors: [.clear, .black],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: fadeHeight)

                        Rectangle().fill(.background)
                    }
                    .padding(.top, -fadeHeight)
                    .ignoresSafeArea(edges: .horizontal)
                }
                // Offsets the content so the backdrop shows above it.
                .padding(
                    .top,
                    backdrop == nil ? fallbackTopPadding : backdropHeight - overlap
                )
        }
        .scrollBounceBehavior(.basedOnSize)
        #if os(iOS) || os(visionOS)
            // Drawn by the navigation container so the backdrop also fills the area
            // behind the toolbar, where a view-level background would be clipped.
            .containerBackground(for: .navigation) {
                backdropLayer
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea()
            }
        #else
            .background(alignment: .top) {
                backdropLayer
                    .ignoresSafeArea(edges: .horizontal)
            }
        #endif
        .ignoresSafeArea(edges: .top)
        .background(.background)
        #if os(iOS) || os(visionOS)
            .toolbarBackground(.hidden, for: .navigationBar)
        #endif
    }

    /// The backdrop at its fixed height, fading out toward the bottom.
    @ViewBuilder
    private var backdropLayer: some View {
        if let backdrop {
            backdrop
                .frame(maxWidth: .infinity)
                .frame(height: backdropHeight)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0.6),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
}

#Preview {
    NavigationStack {
        BackdropScrollView(
            backdropHeight: 420,
            backdrop: LinearGradient(
                colors: [.pink, .orange],
                startPoint: .top,
                endPoint: .bottom
            )
        ) {
            VStack(alignment: .leading, spacing: 24) {
                LeadingHeading("Backdrop Scroll View")
                ForEach(0..<20) { index in
                    Text("Row \(index)")
                }
            }
            .padding()
        }
    }
}
