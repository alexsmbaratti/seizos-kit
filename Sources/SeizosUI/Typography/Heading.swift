//
//  Heading.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/21/25.
//

import SwiftUI

/// A bold, leading-aligned heading view for section titles.
///
/// `Heading` displays localized text using the `.title2` font and bold weight,
/// aligned to the leading edge with trailing space. It applies
/// the appropriate accessibility header trait so assistive technologies
/// recognize it as a section heading.
///
/// - Parameter text: A localized string key used as the heading’s title.
public struct Heading: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        LeadingText(text)
            .font(.title2)
            .fontWeight(.bold)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    VStack {
        Heading("Heading")
        Spacer()
    }
    .padding()
}
