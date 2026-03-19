//
//  SplitDetailView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 3/18/26.
//

import SwiftUI

struct SplitDetailView<
    CompactContent: View,
    LeadingContent: View,
    TrailingContent: View
>: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    let compactContent: CompactContent
    let leadingContent: LeadingContent
    let trailingContent: TrailingContent
    let widthRatio: CGFloat = 2 / 3

    init(
        @ViewBuilder compact: () -> CompactContent,
        @ViewBuilder leading: () -> LeadingContent,
        @ViewBuilder trailing: () -> TrailingContent,
        _ widthRatio: CGFloat = 2 / 3
    ) {
        self.compactContent = compact()
        self.leadingContent = leading()
        self.trailingContent = trailing()
    }

    var body: some View {
        ScrollView {
            if sizeClass == .compact {
                compactContent
            } else {
                GeometryReader { geometry in
                    HStack(spacing: 16) {
                        leadingContent
                            .frame(
                                maxWidth: geometry.size.width * widthRatio,
                                maxHeight: .infinity
                            )
                        trailingContent
                            .frame(
                                maxWidth: geometry.size.width
                                    * (1 - widthRatio),
                                maxHeight: .infinity
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    SplitDetailView(
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
}
