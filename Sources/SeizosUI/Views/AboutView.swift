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
    private let dependencyCredits: [AttributionCredit]

    public init(
        appName: LocalizedStringKey,
        appVersion: String,
        buildNumber: String,
        appIcon: Image,
        credits: [IndividualCredit],
        dependencyCredits: [AttributionCredit]
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
                AttributionCreditsSection(
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
                    .accessibility(hidden: true)

                Text(appName)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(
                    showsBuildNumber
                        ? "\(appVersion) (\(buildNumber))"
                        : appVersion
                )
                .accessibilityLabel(
                    showsBuildNumber
                        ? "Version \(appVersion), Build Number (\(buildNumber))"
                        : "Version \(appVersion)"
                )
                .accessibilityHint("Reveals build number")
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

public struct AttributionCredit: Identifiable {
    public let id: UUID
    public let name: String
    public let description: String
    public let url: URL?

    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        url: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.url = url
    }
}

public struct AttributionCreditsSection: View {
    private let credits: [AttributionCredit]

    public init(credits: [AttributionCredit]) {
        self.credits = credits
    }

    public var body: some View {
        Section(header: Text("attributionCredits.header", bundle: .module)) {
            ForEach(credits) { item in
                VStack {
                    LeadingText(item.name)
                        .onTapGesture {
                            #if canImport(UIKit) && (os(iOS) || os(visionOS))
                                if let url = item.url {
                                    UIApplication.shared.open(url)
                                }
                            #endif
                        }
                    LeadingText(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
                #if canImport(UIKit) && (os(iOS) || os(visionOS))
                .accessibilityHint(item.url != nil ? "Opens the associated webpage" : "")
                #endif
                .padding(.vertical, 6)
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
                AttributionCredit(
                    name: "SeizosKit",
                    description:
                        "Provides reusable UI views and utilities, including this view!",
                    url: URL(
                        string: "https://github.com/alexsmbaratti/seizos-kit"
                    )
                )
            ]
        )
        .navigationTitle("About")
    }
}
