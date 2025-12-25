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
            Spacer()
            text
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    VStack {
        CenteredText("Hello, world!")
        Spacer()
    }
    .padding()
}
