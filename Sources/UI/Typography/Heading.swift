//
//  Heading.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/21/25.
//

import SwiftUI

public struct Heading: View {
    private let text: LocalizedStringKey

    public init(_ text: LocalizedStringKey) {
        self.text = text
    }

    public var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            Spacer()
        }
    }
}
