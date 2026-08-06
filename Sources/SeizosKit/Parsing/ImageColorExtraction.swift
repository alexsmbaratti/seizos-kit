//
//  ImageColorExtraction.swift
//  SeizosKit
//
//  Created by Alex Baratti on 7/30/26.
//

import CoreGraphics
import SwiftUI

/// A strategy for deriving a single representative `Color` from an image.
public enum ImageColorExtractionStrategy: Sendable {
    /// The mean color across every pixel.
    case average
    /// The most frequently occurring color, after quantizing similar colors together.
    case dominant
}

extension CGImage {
    /// Derives a representative color from the image using the given strategy.
    ///
    /// The image is downsampled before analysis, so this is cheap enough to call
    /// synchronously, but it still shouldn't be re-run every frame for a view that
    /// redraws often — compute it once and cache the resulting `Color` if that applies.
    func representativeColor(using strategy: ImageColorExtractionStrategy) -> Color {
        switch strategy {
        case .average:
            Self.averageColor(of: self)
        case .dominant:
            Self.dominantColor(of: self)
        }
    }

    private static func averageColor(of image: CGImage) -> Color {
        var pixel: [UInt8] = [0, 0, 0, 0]
        guard
            let context = CGContext(
                data: &pixel,
                width: 1,
                height: 1,
                bitsPerComponent: 8,
                bytesPerRow: 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else {
            return .gray
        }

        context.interpolationQuality = .medium
        context.draw(image, in: CGRect(x: 0, y: 0, width: 1, height: 1))

        return Color(
            red: Double(pixel[0]) / 255,
            green: Double(pixel[1]) / 255,
            blue: Double(pixel[2]) / 255
        )
    }

    private static func dominantColor(of image: CGImage) -> Color {
        let side = 32
        var pixels = [UInt8](repeating: 0, count: side * side * 4)
        guard
            let context = CGContext(
                data: &pixels,
                width: side,
                height: side,
                bitsPerComponent: 8,
                bytesPerRow: side * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            )
        else {
            return .gray
        }

        context.interpolationQuality = .medium
        context.draw(image, in: CGRect(x: 0, y: 0, width: side, height: side))

        // Quantize into 16-value buckets per channel so near-identical colors
        // count as one, then take the most frequent bucket.
        func bucket(_ component: UInt8) -> UInt32 {
            UInt32(component / 16) * 16
        }

        var counts: [UInt32: Int] = [:]
        for i in stride(from: 0, to: pixels.count, by: 4) {
            guard pixels[i + 3] > 0 else { continue }
            let key =
                bucket(pixels[i]) << 16 | bucket(pixels[i + 1]) << 8
                | bucket(pixels[i + 2])
            counts[key, default: 0] += 1
        }

        guard let dominant = counts.max(by: { $0.value < $1.value })?.key else {
            return .gray
        }

        return Color(
            red: Double((dominant >> 16) & 0xFF) / 255,
            green: Double((dominant >> 8) & 0xFF) / 255,
            blue: Double(dominant & 0xFF) / 255
        )
    }
}
