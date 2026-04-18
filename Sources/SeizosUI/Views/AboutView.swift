//
//  AboutView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

/// An all-in-one declarative view for displaying information about the app, including version and credits.
///
/// - Parameter appName: A localized string key for the app's localized name.
/// - Parameter appVersion: A string for the app's version number.
/// - Parameter buildNumber: A string for the app's build number. Hidden by default. Displayed upon tapping the app's version number.
/// - Parameter appIcon: An image for the app's icon.
/// - Parameter creditsHeader: A localized string key for the header of the credits section.
/// - Parameter credits: A list of Credit structs representing the credits.
public struct AboutView: View {
    private let appName: LocalizedStringKey
    private let appVersion: String
    private let buildNumber: String
    private let appIcon: Image
    private let individualCredits: [IndividualCredit]
    private let dependencyCredits: [DependencyCredit]

    public init(
        appName: LocalizedStringKey,
        appVersion: String,
        buildNumber: String,
        appIcon: Image,
        credits: [IndividualCredit],
        dependencyCredits: [DependencyCredit]
    ) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.appIcon = appIcon
        self.individualCredits = credits
        self.dependencyCredits = dependencyCredits
    }

    public var body: some View {
        List {
            AppInfoSection(
                appName: appName,
                appVersion: appVersion,
                buildNumber: buildNumber,
                appIcon: appIcon
            )

            IndividualCreditsSection(
                credits: individualCredits
            )

            if !dependencyCredits.isEmpty {
                DependencyCreditsSection(
                    credits: dependencyCredits
                )
            }
        }
    }
}

/// A section that displays the app name, app icon, and app version. Intended to be displayed within a List. Tapping the version will reveal the build number.
///
/// - Parameter appName: A localized string key for the app's localized name.
/// - Parameter appVersion: A string for the app's version number.
/// - Parameter buildNumber: A string for the app's build number. Hidden by default. Displayed upon tapping the app's version number.
/// - Parameter appIcon: An image for the app's icon.
public struct AppInfoSection: View {
    private let appName: LocalizedStringKey
    private let appVersion: String
    private let buildNumber: String
    private let appIcon: Image

    @State private var showsBuildNumber = false

    public init(
        appName: LocalizedStringKey,
        appVersion: String,
        buildNumber: String,
        appIcon: Image
    ) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.appIcon = appIcon
    }

    public var body: some View {
        Section {
            VStack {
                appIcon
                    .resizable()
                    .frame(width: 80, height: 80)
                    .shadow(radius: 4)

                Text(appName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(
                    showsBuildNumber
                        ? "\(appVersion) (\(buildNumber))"
                        : appVersion
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .onTapGesture {
                    showsBuildNumber = true
                }
            }
            .horizontallyCentered()
            .padding(.vertical, 20)
        }
    }
}

/// A model representing an individual credited in an app’s credits section.
///
/// `IndividualCredit` is intended for UI presentation only and is typically displayed
/// using `IndividualCreditsSection`. It pairs a person’s name with a localized role
/// or contribution, such as “Developer” or “Designer”.
public struct IndividualCredit: Identifiable {
    public let id: UUID
    public let name: String
    public let role: LocalizedStringKey

    public init(
        id: UUID = UUID(),
        name: String,
        role: LocalizedStringKey
    ) {
        self.id = id
        self.name = name
        self.role = role
    }
}

public struct IndividualCreditsSection: View {
    private let credits: [IndividualCredit]

    public init(credits: [IndividualCredit]) {
        self.credits = credits
    }

    public var body: some View {
        Section(header: Text("individualCredits.header", bundle: .module)) {
            ForEach(credits) { credit in
                LabeledContent(credit.role, value: credit.name)
            }
        }
    }
}

public struct DependencyCredit: Identifiable {
    public let id: UUID
    public let name: String
    public let description: String
    public let licenseText: String?
    public let url: URL?

    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        licenseText: String? = nil,
        url: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.licenseText = licenseText
        self.url = url
    }
}

public struct DependencyCreditsSection: View {
    private let credits: [DependencyCredit]

    public init(credits: [DependencyCredit]) {
        self.credits = credits
    }

    public var body: some View {
        Section(header: Text("dependencyCredits.header", bundle: .module)) {
            ForEach(credits) { item in
                DependencyCreditView(dependencyCredit: item)
            }
        }
    }
}

public struct DependencyCreditView: View {
    private let dependencyCredit: DependencyCredit

    @State private var showLicenseText = "Show License"

    public init(dependencyCredit: DependencyCredit) {
        self.dependencyCredit = dependencyCredit
    }

    public var body: some View {
        VStack {
            LeadingText(dependencyCredit.name)
            LeadingText(dependencyCredit.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let licenseText = dependencyCredit.licenseText {
                Divider()
                LeadingText(showLicenseText)
                    .onTapGesture {
                        showLicenseText = licenseText
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutView(
            appName: "Foo Bar",
            appVersion: "1.0",
            buildNumber: "1",
            appIcon: Image(systemName: "app.fill"),
            credits: [
                IndividualCredit(name: "Alex Baratti", role: "Developer"),
                IndividualCredit(name: "Alex Baratti", role: "Designer"),
            ],
            dependencyCredits: [
                DependencyCredit(
                    name: "SeizosKit",
                    description:
                        "Provides reusable UI views and utilities, including this view!",
                    licenseText: """
                        MIT License

                        Copyright (c) 2025 Alex Baratti

                        Permission is hereby granted, free of charge, to any person obtaining a copy
                        of this software and associated documentation files (the "Software"), to deal
                        in the Software without restriction, including without limitation the rights
                        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
                        copies of the Software, and to permit persons to whom the Software is
                        furnished to do so, subject to the following conditions:

                        The above copyright notice and this permission notice shall be included in all
                        copies or substantial portions of the Software.

                        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
                        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                        SOFTWARE.
                        """,
                    url: URL(
                        string: "https://github.com/alexsmbaratti/seizos-kit"
                    )
                )
            ]
        )
        .navigationTitle("About")
    }
}
