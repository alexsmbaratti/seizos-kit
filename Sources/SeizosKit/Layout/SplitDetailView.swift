//
//  SplitDetailView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 3/18/26.
//

import SwiftUI

public struct SplitDetailView<
    HeaderContent: View,
    CompactContent: View,
    LeadingContent: View,
    TrailingContent: View
>: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    let headerContent: HeaderContent
    let compactContent: CompactContent
    let leadingContent: LeadingContent
    let trailingContent: TrailingContent
    let widthRatio: CGFloat = 3 / 5

    public init(
        @ViewBuilder header: () -> HeaderContent,
        @ViewBuilder compact: () -> CompactContent,
        @ViewBuilder leading: () -> LeadingContent,
        @ViewBuilder trailing: () -> TrailingContent
    ) {
        self.headerContent = header()
        self.compactContent = compact()
        self.leadingContent = leading()
        self.trailingContent = trailing()
    }

    public var body: some View {
        VStack {
            if sizeClass == .compact {
                headerContent
                compactContent
            } else {
                headerContent
                GeometryReader { geometry in
                    HStack(alignment: .top, spacing: 16) {
                        leadingContent
                            .frame(
                                minWidth: 300,
                                maxWidth: geometry.size.width * widthRatio
                            )
                        trailingContent
                            .frame(
                                minWidth: 300,
                                maxWidth: geometry.size.width
                                    * (1 - widthRatio)
                            )
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ScrollView {
        SplitDetailView(
            header: {
                VStack {
                    LeadingText("Hello, World")
                        .font(.title)
                        .bold()
                    LeadingText("Hello, World")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                    Divider()
                }
            },
            compact: {
                VStack {
                    Text("Leading")
                    Text("Trailing")
                }
            },
            leading: {
                VStack {
                    Text("Leading")
                }
            },
            trailing: {
                VStack {
                    Text("Trailing")
                }
            }
        )
        .padding([.leading, .bottom, .trailing])
    }
}
