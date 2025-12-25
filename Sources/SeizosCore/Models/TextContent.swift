//
//  TextContent.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/25/25.
//

import SwiftUI

public struct TextContent {
    fileprivate let text: Text

    public init(_ key: LocalizedStringKey) {
        self.text = Text(key)
    }

    public init(_ string: String) {
        self.text = Text(string)
    }

    public init(_ text: Text) {
        self.text = text
    }
}
