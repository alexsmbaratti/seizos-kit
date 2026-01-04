//
//  StarRatingView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 1/3/26.
//

import SwiftUI

public struct StarRatingView: View {
    @Binding private var rating: Int
    private let maxRating: Int
    private let fillColor: Color
    private let isEditable: Bool
    
    public init(
            rating: Binding<Int>,
            maxRating: Int = 5,
            fillColor: Color = .yellow,
            isEditable: Bool = true
        ) {
            self._rating = rating
            self.maxRating = maxRating
            self.fillColor = fillColor
            self.isEditable = isEditable
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
        }
}

#Preview {
    StarRatingView(rating: .constant(3))
}
