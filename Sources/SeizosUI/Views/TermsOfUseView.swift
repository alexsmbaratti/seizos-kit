//
//  TermsOfUseView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/28/25.
//

import SwiftUI
import SeizosCore

/// A view for displaying terms of use for an app. Applies bold formatting for numbered headers in the provided terms of use. Also displays the provided string indicating the last update of the terms of use.
///
/// - Parameter termsOfUse: A string representing the terms of use (optionally with numbered headers for formatting).
/// - Parameter lastUpdatedText: A string representing the last update of the terms of use (i.e. `Last Updated: January 1, 1970`).
public struct TermsOfUseView: View {
    @State private var termsContent: AttributedString = AttributedString("")
    
    private let termsOfUse: String
    private let lastUpdatedText: String
    
    public init(termsOfUse: String, lastUpdatedText: String) {
        self.termsOfUse = termsOfUse
        self.lastUpdatedText = lastUpdatedText
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(lastUpdatedText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text(termsContent)
            }
            .padding()
        }
        .task {
            formatTermsContent(termsOfUse)
        }
    }
    
    private func formatTermsContent(_ content: String) {
        var attributedContent = AttributedString(content)
        
        let headingPattern = try? NSRegularExpression(pattern: "^\\d+\\..*$", options: .anchorsMatchLines)
        
        if let headingPattern = headingPattern,
           let contentRange = Range(NSRange(location: 0, length: content.utf16.count), in: content) {
            
            let matches = headingPattern.matches(in: content, range: NSRange(contentRange, in: content))
            
            for match in matches {
                if let matchRange = Range(match.range, in: content) {
                    let headingText = String(content[matchRange])
                    
                    if let attrRange = attributedContent.range(of: headingText) {
                        attributedContent[attrRange].font = .headline
                        attributedContent[attrRange].foregroundColor = .primary
                    }
                }
            }
        }
        
        termsContent = attributedContent
    }
}

#Preview {
    let termsOfUse = """
By accessing or using this service, you agree to be bound by these Terms of Use.

1. Lorem Ipsum

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate, nisl nec vulputate pulvinar, ex libero consectetur arcu, eu egestas ante dui ac lacus. Maecenas luctus risus velit, sit amet sodales leo accumsan cursus. Curabitur convallis diam eget quam dictum sollicitudin in et leo. Phasellus efficitur posuere porttitor. Nullam hendrerit, augue in accumsan blandit, metus enim lacinia lorem, sit amet scelerisque purus sapien auctor ipsum. Fusce euismod sollicitudin dui nec scelerisque. 

2. Pellentesque Habitant

Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc consequat justo a mauris pharetra, at vestibulum felis pulvinar. Nulla et blandit est:

- Etiam nec ante id arcu aliquam condimentum. 
- Aliquam vitae tincidunt dui. 
- Nullam libero diam, fringilla in leo quis, malesuada tristique est. 

3. Vestibulum Vitae Semper

Vestibulum vitae semper elit. Nam vel diam sit amet lorem vestibulum aliquam a ultricies enim. Proin convallis suscipit blandit. Cras in ligula blandit, placerat eros non, sollicitudin diam. Nunc at tempus elit. Duis vitae ultricies justo, sed hendrerit est. Pellentesque sollicitudin volutpat urna, eget tincidunt nibh tristique sed. Proin vitae sapien justo.

4. Donec Non Velit Sit Amet Lacus

Donec non velit sit amet lacus fermentum volutpat. Vivamus euismod elit a dui mattis commodo. Morbi eget risus enim. Nunc id nibh sit amet nisl imperdiet accumsan in quis eros. Vivamus imperdiet consectetur metus non facilisis. Nunc quis porttitor sem. Sed luctus vitae tortor ut mattis. Vestibulum sit amet neque vehicula, volutpat ex pharetra, aliquam ligula. Nullam nec magna consectetur, bibendum elit ultricies, dictum lectus. Sed auctor id lacus vitae dapibus.

5. Sed Sapien Risus

Sed sapien risus, placerat id efficitur nec, feugiat at dui. Nulla nec risus ipsum. Vestibulum tristique arcu orci, sed varius massa faucibus ac. Ut scelerisque est a neque sagittis, ac bibendum sem ultricies. Praesent egestas lacus lobortis nisi convallis luctus. Vivamus tellus sapien, mattis nec tortor sit amet, ullamcorper egestas leo. Vivamus eu risus ante. Sed hendrerit accumsan odio.

6. Changes to the Terms

We reserve the right to modify or update these Terms at any time without prior notice. Continued use of Pixel Shelf following any changes indicates your acceptance of the updated Terms.
"""
    let lastUpdatedText = "Last Updated: \(Calendar.current.date(from: DateComponents(year: 1970, month: 1, day: 1))!.formattedLongDate())"
    return NavigationStack {
        TermsOfUseView(termsOfUse: termsOfUse, lastUpdatedText: lastUpdatedText)
            .navigationTitle("Terms of Use")
    }
}
