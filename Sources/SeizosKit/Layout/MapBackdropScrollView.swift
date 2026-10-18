//
//  MapBackdropScrollView.swift
//  SeizosKit
//
//  Created by Alex Baratti on 10/18/26.
//

import MapKit
import SwiftUI

/// A ``BackdropScrollView`` whose backdrop is a non-interactive map with a marker.
///
/// When `coordinate` is `nil`, no map is shown and the content is offset by `fallbackTopPadding`.
public struct MapBackdropScrollView<Content: View>: View {
    private let coordinate: CLLocationCoordinate2D?
    private let markerTitle: String
    private let markerTint: Color
    private let mapHeight: CGFloat
    private let overlap: CGFloat
    private let fadeHeight: CGFloat
    private let fallbackTopPadding: CGFloat
    private let content: Content

    /// - Parameters:
    ///   - coordinate: The location to show and mark, or `nil` to omit the map.
    ///   - markerTitle: The title of the marker.
    ///   - markerTint: The tint of the marker. Defaults to `.red`.
    ///   - mapHeight: The height of the map. Defaults to `420`.
    ///   - overlap: How far the content overlaps the bottom of the map. Defaults to `120`.
    ///   - fadeHeight: The height of the dissolve between the map and the content. Defaults to `160`.
    ///   - fallbackTopPadding: The padding above the content when there is no map. Defaults to `80`.
    ///   - content: The scrolling content.
    public init(
        coordinate: CLLocationCoordinate2D?,
        markerTitle: String,
        markerTint: Color = .red,
        mapHeight: CGFloat = 420,
        overlap: CGFloat = 120,
        fadeHeight: CGFloat = 160,
        fallbackTopPadding: CGFloat = 80,
        @ViewBuilder content: () -> Content
    ) {
        self.coordinate = coordinate
        self.markerTitle = markerTitle
        self.markerTint = markerTint
        self.mapHeight = mapHeight
        self.overlap = overlap
        self.fadeHeight = fadeHeight
        self.fallbackTopPadding = fallbackTopPadding
        self.content = content()
    }

    public var body: some View {
        BackdropScrollView(
            backdropHeight: mapHeight,
            overlap: overlap,
            fadeHeight: fadeHeight,
            fallbackTopPadding: fallbackTopPadding,
            backdrop: coordinate.map { map(at: $0) }
        ) {
            content
        }
    }

    private func map(at coordinate: CLLocationCoordinate2D) -> some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    // Centered south of the pin so it sits in the upper part
                    // of the map, clear of the dissolve.
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.latitude - 0.001,
                        longitude: coordinate.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            ),
            interactionModes: []
        ) {
            Marker(markerTitle, coordinate: coordinate)
                .tint(markerTint)
        }
        .mapStyle(.standard)
    }
}

#Preview {
    NavigationStack {
        MapBackdropScrollView(
            coordinate: CLLocationCoordinate2D(latitude: 35.0394, longitude: 135.7292),
            markerTitle: "Kinkaku-ji",
            markerTint: .pink
        ) {
            VStack(alignment: .leading, spacing: 24) {
                LeadingHeading("Map Backdrop Scroll View")
                ForEach(0..<20) { index in
                    Text("Row \(index)")
                }
            }
            .padding()
        }
    }
}
