//
//  AppIconPickerView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/22/26.
//

import SwiftUI

#if os(iOS)
    /// A list of alternate app icons the user can select from.
    ///
    /// Selecting an option updates the app's icon via `UIApplication.setAlternateIconName(_:completionHandler:)`.
    ///
    /// Available on iOS only, since alternate app icons are a UIKit/iOS-specific
    /// feature with no equivalent API on other platforms such as visionOS.
    struct AppIconPickerView: View {
        let options: [AppIconOption]
        @State private var selection: String?

        init(options: [AppIconOption]) {
            self.options = options
            _selection = State(
                initialValue: UIApplication.shared.alternateIconName
            )
        }

        var body: some View {
            List {
                Section {
                    ForEach(options) { option in
                        Button {
                            select(option)
                        } label: {
                            label(for: option)
                        }
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

        @ViewBuilder
        private func label(for option: AppIconOption) -> some View {
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

                Text(option.displayName)
                    .foregroundStyle(.primary)

                Spacer()

                if selection == option.id {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.tint)
                }
            }
        }
    }
#endif

struct AppIconOption: Identifiable {
    let id: String?
    let displayName: LocalizedStringKey
    let description: LocalizedStringKey?
    let preview: Image
}
