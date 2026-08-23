//
//  AppIconPickerView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/22/26.
//

import SwiftUI

/// One selectable entry in an app icon picker — either the app's primary/default
/// icon (`id == nil`) or an alternate icon registered via `CFBundleAlternateIcons`.
public struct AppIconOption: Identifiable {
    public let id: String?
    public let displayName: LocalizedStringKey
    public let description: LocalizedStringKey?
    public let preview: Image

    public init(
        id: String?,
        displayName: LocalizedStringKey,
        description: LocalizedStringKey? = nil,
        preview: Image
    ) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.preview = preview
    }
}

/// The visual content of a single row in an app icon picker — icon preview, name,
/// optional description, and a checkmark when selected.
///
/// Contains no tap handling or icon-switching logic of its own; wrap it in a
/// `Button` (or other control) to make it interactive.
public struct AppIconOptionRow: View {
    private let option: AppIconOption
    private let isSelected: Bool

    public init(option: AppIconOption, isSelected: Bool) {
        self.option = option
        self.isSelected = isSelected
    }

    public var body: some View {
        HStack {
            option.preview
                .resizable()
                .frame(width: 44, height: 44)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading) {
                Text(option.displayName)
                    .foregroundStyle(.primary)

                if let description = option.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundStyle(.tint)
            }
        }
    }
}

#if os(iOS)
    /// A section listing selectable app icons. Intended to be displayed within a `List`.
    ///
    /// Tapping an option updates the app's icon via
    /// `UIApplication.setAlternateIconName(_:completionHandler:)`.
    public struct AppIconPickerSection: View {
        private let options: [AppIconOption]
        @State private var selection: String?

        public init(options: [AppIconOption]) {
            self.options = options
            _selection = State(
                initialValue: UIApplication.shared.alternateIconName
            )
        }

        public var body: some View {
            Section {
                ForEach(options) { option in
                    Button {
                        select(option)
                    } label: {
                        AppIconOptionRow(
                            option: option,
                            isSelected: selection == option.id
                        )
                    }
                }
            }
        }

        private func select(_ option: AppIconOption) {
            guard selection != option.id else { return }

            UIApplication.shared.setAlternateIconName(option.id) { error in
                if let error {
                    print(
                        "Failed to set alternate icon name: \(error.localizedDescription)"
                    )
                    return
                }
                selection = option.id
            }
        }
    }

    /// An all-in-one declarative view for picking an alternate app icon.
    ///
    /// Available on iOS only, since alternate app icons are a UIKit/iOS-specific
    /// feature with no equivalent API on other platforms such as visionOS.
    public struct AppIconPickerView: View {
        private let options: [AppIconOption]

        public init(options: [AppIconOption]) {
            self.options = options
        }

        public var body: some View {
            List {
                AppIconPickerSection(options: options)
            }
        }
    }

    #Preview {
        NavigationStack {
            AppIconPickerView(
                options: [
                    AppIconOption(
                        id: nil,
                        displayName: "Default",
                        preview: Image(systemName: "app.fill")
                    ),
                    AppIconOption(
                        id: "AppIcon-Alternate",
                        displayName: "Alternate",
                        description: "A limited-time icon.",
                        preview: Image(systemName: "app.fill")
                    ),
                ]
            )
            .navigationTitle("App Icon")
        }
    }
#endif
