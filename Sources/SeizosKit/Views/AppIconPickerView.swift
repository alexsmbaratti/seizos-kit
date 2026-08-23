//
//  AppIconPickerView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 8/22/26.
//

import SwiftUI

struct AppIconPickerView: View {
    let options: [AppIconOption]
    @State private var selection: String?

    init(options: [AppIconOption]) {
        self.options = options
        #if canImport(UIKit) && os(iOS)
            _selection = State(
                initialValue: UIApplication.shared.alternateIconName
            )
        #else
            _selection = State(initialValue: nil)
        #endif
    }

    var body: some View {
        List {
            Section {
                ForEach(options) { option in
                    Button {
                        select(option)
                    } label: {
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
            }
        }
    }
}

struct AppIconOption: Identifiable {
    let id: String?
    let displayName: LocalizedStringKey
    let description: LocalizedStringKey?
    let preview: Image
}
