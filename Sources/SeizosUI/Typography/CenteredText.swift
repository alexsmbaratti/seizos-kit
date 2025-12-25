//
//  CenteredText.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/25/25.
//

import SwiftUI

/// A view that displays localized text centered horizontally.
///
/// Font can be adjusted with the `.font()` modifier.
public struct CenteredText: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        HStack {
            Spacer()
            Text(text)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
