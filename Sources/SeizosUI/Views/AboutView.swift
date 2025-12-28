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
    private let individualCreditsHeader: LocalizedStringKey
    private let individualCredits: [IndividualCredit]
    private let dependencyCreditsHeader: LocalizedStringKey
    private let dependencyCredits: [DependencyCredit]
    
    public init(appName: LocalizedStringKey, appVersion: String, buildNumber: String, appIcon: Image, individualCreditsHeader: LocalizedStringKey, credits: [IndividualCredit], dependencyCreditsHeader: LocalizedStringKey, dependencyCredits: [DependencyCredit]) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.appIcon = appIcon
        self.individualCreditsHeader = individualCreditsHeader
        self.individualCredits = credits
        self.dependencyCreditsHeader = dependencyCreditsHeader
        self.dependencyCredits = dependencyCredits
    }
    
    public var body: some View {
        List {
            AppInfoSection(appName: appName, appVersion: appVersion, buildNumber: buildNumber, appIcon: appIcon)
            
            IndividualCreditsSection(header: individualCreditsHeader, credits: individualCredits)
            
            if !dependencyCredits.isEmpty {
                DependencyCreditsSection(header: dependencyCreditsHeader, credits: dependencyCredits)
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
    
    public init(appName: LocalizedStringKey, appVersion: String, buildNumber: String, appIcon: Image) {
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
                
                Text(showsBuildNumber
                     ? "\(appVersion) (\(buildNumber))"
                     : appVersion)
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
    private let header: LocalizedStringKey
    private let credits: [IndividualCredit]
    
    public init(header: LocalizedStringKey, credits: [IndividualCredit]) {
        self.header = header
        self.credits = credits
    }
    
    public var body: some View {
        Section(header) {
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

public struct DependencyCreditsSection: View {
    private let header: LocalizedStringKey
    private let credits: [DependencyCredit]
    
    public init(header: LocalizedStringKey, credits: [DependencyCredit]) {
        self.header = header
        self.credits = credits
    }
    
    public var body: some View {
        Section(header) {
            ForEach(credits) { item in
                VStack {
                    LeadingText(item.name)
                    LeadingText(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
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
            individualCreditsHeader: "Credits",
            credits: [IndividualCredit(name: "Alex Baratti", role: "Developer"), IndividualCredit(name: "Alex Baratti", role: "Designer")], dependencyCreditsHeader: "Packages", dependencyCredits: [DependencyCredit(name: "SeizosKit", description: "Provides reusable UI views and utilities, including this view!", url: URL(string: "https://github.com/alexsmbaratti/seizos-kit"))]
        )
        .navigationTitle("About")
    }
}
