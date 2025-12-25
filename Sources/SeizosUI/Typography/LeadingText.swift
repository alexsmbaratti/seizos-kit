//
//  LeadingText.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/25/25.
//

import SwiftUI

/// A view that displays localized text leading-aligned.
///
/// Font can be adjusted with the `.font()` modifier.
public struct LeadingText: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        HStack {
            Text(text)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    VStack {
        LeadingText("Hello, world!")
        Spacer()
    }
    .padding()
}
