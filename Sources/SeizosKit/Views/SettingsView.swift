//
//  SettingsView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/24/26.
//

import SwiftUI

/// A `NavigationLink` to an app's About screen, labeled with a localized "About" title
/// and an "info.circle" icon.
///
/// Intended to be placed within a `List`, alongside other app-specific settings rows.
public struct AboutLink<Destination: View>: View {
    private let destination: Destination

    public init(destination: Destination) {
        self.destination = destination
    }

    public var body: some View {
        NavigationLink(destination: destination) {
            Label {
                Text("about.title", bundle: .module)
            } icon: {
                Image(systemName: "info.circle")
            }
        }
    }
}

/// A `Link` to an app's privacy policy webpage, labeled with a localized "Privacy Policy"
/// title and a "hand.raised" icon.
///
/// Intended to be placed within a `List`, alongside other app-specific settings rows.
public struct PrivacyPolicyLink: View {
    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        Link(destination: url) {
            Label {
                Text("privacyPolicy.title", bundle: .module)
            } icon: {
                Image(systemName: "hand.raised")
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            Section {
                AboutLink(destination: Text("About Destination"))
                PrivacyPolicyLink(
                    url: URL(string: "https://example.com/privacy-policy")!
                )
            }
        }
    }
}
