//
//  StarRatingView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 1/3/26.
//

import SwiftUI

/// A declarative view for displaying a star rating system, with customizations for fill color and number of stars.
///
/// - Note:
/// For full accessibility and localization, consumers should provide localized accessibility labels and values.
///
/// - Parameter rating: A binding to the number of filled stars. Pass a constant binding if the view is intended to be read-only.
/// - Parameter maxRating: The maximum number of stars possible. For example, for a five-star rating system, the `maxRating` would be `5`.
/// - Parameter fillColor: The color of filled stars. Defaults to yellow.
/// - Parameter isEditable: Whether the rating is dynamic.
/// - Parameter accessibilityLabel: A localized string key representing the label for this view (i.e. "Rating").
/// - Parameter accessibilityValue: A localized string key representing the value for this view (i.e. "3 out of 5 stars"). Used for VoiceOver. This should incorporate `rating` and `maxRating`.
public struct StarRatingView: View {
    @Binding private var rating: Int
    private let maxRating: Int
    private let fillColor: Color
    private let isEditable: Bool
    private let accessibilityLabel: LocalizedStringKey
    private let accessibilityValue: LocalizedStringKey

    public init(
        rating: Binding<Int>,
        maxRating: Int = 5,
        fillColor: Color = .yellow,
        isEditable: Bool = true,
        accessibilityLabel: LocalizedStringKey = "",
        accessibilityValue: LocalizedStringKey = ""
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.fillColor = fillColor
        self.isEditable = isEditable
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? fillColor : .gray)
                    .onTapGesture {
                        guard isEditable else { return }
                        rating = index
                    }
            }
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityAdjustableAction { direction in
            guard isEditable else { return }

            switch direction {
            case .increment:
                rating = min(rating + 1, maxRating)
            case .decrement:
                rating = max(rating - 1, 1)
            default:
                break
            }
        }
    }
}

#Preview {
    StarRatingView(rating: .constant(3))
}
