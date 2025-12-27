//
//  AboutView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/27/25.
//

import SwiftUI

struct AboutView: View {
    private let appName: LocalizedStringKey
    private let appVersion: String
    private let buildNumber: String
    private let appIcon: Image
    private let developerName: String
    
    public init(appName: LocalizedStringKey, appVersion: String, buildNumber: String, appIcon: Image, developerName: String) {
        self.appName = appName
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.appIcon = appIcon
        self.developerName = developerName
    }
    
    var body: some View {
        List {
            AppInfoSection(appName: appName, appVersion: appVersion, buildNumber: buildNumber, appIcon: appIcon)
            
            Section("settings-credits-header") {
                LabeledContent("Developer", value: developerName)
            }
        }
    }
}

/// A section that displays the app name, app icon, and app version. Intended to be displayed within a List. Tapping the version will reveal the build number.
///
/// - Parameter appName: A localized string key for the app's localized name.
/// - Parameter appVersion: A string for the app's version number.
/// - Parameter buildNumber: A string for the app's build number.
/// - Parameter appIcon: An image for the app's icon.
struct AppInfoSection: View {
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
    
    var body: some View {
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

#Preview {
    NavigationStack {
        AboutView(
            appName: "Foo Bar",
            appVersion: "1.0",
            buildNumber: "1",
            appIcon: Image(systemName: "app.fill"),
            developerName: "Alex Baratti"
        )
        .navigationTitle("About")
    }
}
