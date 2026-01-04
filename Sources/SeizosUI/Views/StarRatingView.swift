//
//  StarRatingView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 1/3/26.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Int8?
    let fillColor: Color? = .yellow
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ?? 0 ? "star.fill" : "star")
                    .foregroundColor(index <= rating ?? 0 ? fillColor : .gray)
            }
        }
    }
}

#Preview {
    StarRatingView(rating: 3)
}
