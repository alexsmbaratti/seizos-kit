//
//  AboutView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

public struct AboutView: View {
    private let appName: LocalizedStringKey
    private let appVersion: String
    private let buildNumber: String
    private let appIcon: Image
    private let creditsHeader: LocalizedStringKey
    private let credits: [Credit]
    
    public init(appName: LocalizedStringKey, appVersion: String, buildNumber: String, appIcon: Image, creditsHeader: LocalizedStringKey, credits: [Credit]) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.appIcon = appIcon
        self.creditsHeader = creditsHeader
        self.credits = credits
    }
    
    public var body: some View {
        List {
            AppInfoSection(appName: appName, appVersion: appVersion, buildNumber: buildNumber, appIcon: appIcon)
            
            CreditsSection(header: creditsHeader, credits: credits)
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
            HStack {
                Spacer()
                VStack(spacing: 10) {
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
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }
}

/// A model representing an individual credited in an app’s credits section.
///
/// `Credit` is intended for UI presentation only and is typically displayed using
/// `CreditsSection`. It pairs a person’s name with a localized role or contribution,
/// such as “Developer” or “Designer”.
public struct Credit: Identifiable {
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

public struct CreditsSection: View {
    private let header: LocalizedStringKey
    private let credits: [Credit]
    
    public init(header: LocalizedStringKey, credits: [Credit]) {
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

#Preview {
    NavigationStack {
        AboutView(
            appName: "Foo Bar",
            appVersion: "1.0",
            buildNumber: "1",
            appIcon: Image(systemName: "app.fill"),
            creditsHeader: "Credits",
            credits: [Credit(name: "Alex Baratti", role: "Developer"), Credit(name: "Alex Baratti", role: "Designer")]
        )
        .navigationTitle("About")
    }
}
