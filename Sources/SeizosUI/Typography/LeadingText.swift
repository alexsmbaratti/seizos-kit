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
    private let text: Text

    public init(_ key: LocalizedStringKey) {
        self.text = Text(key)
    }
    
    public init(_ string: String) {
        self.text = Text(string)
    }
    
    public init(_ text: Text) {
        self.text = text
    }

    public var body: some View {
        HStack {
            text
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

#Preview {
    LeadingText("Hello, world!")
        .pinnedToTop()
        .padding()
}
