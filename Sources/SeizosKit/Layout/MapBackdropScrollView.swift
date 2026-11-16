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
/// When `coordinate` is `nil`, no map is shown and this is a plain scroll view.
public struct MapBackdropScrollView<Content: View>: View {
    private let coordinate: CLLocationCoordinate2D?
    private let markerTitle: String
    private let markerTint: Color
    private let markerSymbol: MapMarkerSymbol?
    private let mapHeight: CGFloat
    private let overlap: CGFloat
    private let fadeHeight: CGFloat
    private let contentOffset: CGFloat
    private let content: Content

    /// - Parameters:
    ///   - coordinate: The location to show and mark, or `nil` to omit the map.
    ///   - markerTitle: The title of the marker.
    ///   - markerTint: The tint of the marker. Defaults to `.red`.
    ///   - markerSymbol: The SF Symbol or custom symbol shown in the marker. Defaults to `nil`,
    ///     which uses the standard marker.
    ///   - mapHeight: The height of the map. Defaults to `420`.
    ///   - overlap: How far the content overlaps the bottom of the map. Defaults to `120`.
    ///   - fadeHeight: The height of the dissolve between the map and the content. Defaults to `160`.
    ///   - contentOffset: A vertical offset applied to the content when the map is shown, so it rides
    ///     up over the map. Negative values move it up. Defaults to `-48`. Ignored when `coordinate` is `nil`.
    ///   - content: The scrolling content.
    public init(
        coordinate: CLLocationCoordinate2D?,
        markerTitle: String,
        markerTint: Color = .red,
        markerSymbol: MapMarkerSymbol? = nil,
        mapHeight: CGFloat = 420,
        overlap: CGFloat = 120,
        fadeHeight: CGFloat = 160,
        contentOffset: CGFloat = -48,
        @ViewBuilder content: () -> Content
    ) {
        self.coordinate = coordinate
        self.markerTitle = markerTitle
        self.markerTint = markerTint
        self.markerSymbol = markerSymbol
        self.mapHeight = mapHeight
        self.overlap = overlap
        self.fadeHeight = fadeHeight
        self.contentOffset = contentOffset
        self.content = content()
    }

    /// How far the visible area's center sits right of the map's center, from the safe area.
    /// On iPad the sidebar floats over the detail column and shows up as a leading safe-area inset.
    @State private var centerShift: CGFloat = 0

    public var body: some View {
        BackdropScrollView(
            backdropHeight: mapHeight,
            overlap: overlap,
            fadeHeight: fadeHeight,
            contentOffset: contentOffset,
            backdrop: coordinate.map { coordinate in
                OffsetMap(
                    coordinate: coordinate,
                    markerTitle: markerTitle,
                    markerTint: markerTint,
                    markerSymbol: markerSymbol,
                    shift: centerShift
                )
                // `initialPosition` is only read on creation, so a new location needs a new map.
                .id(MapKey(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        ) {
            content
        }
        .background {
            GeometryReader { proxy in
                let insets = proxy.safeAreaInsets
                Color.clear
                    .onChange(of: (insets.leading - insets.trailing) / 2, initial: true) { _, shift in
                        centerShift = shift
                    }
            }
        }
    }
}

/// A non-interactive map that keeps its marker centered in the part of the map that isn't
/// covered, shifting the camera by `shift` points as the covered area changes.
private struct OffsetMap: View {
    let coordinate: CLLocationCoordinate2D
    let markerTitle: String
    let markerTint: Color
    let markerSymbol: MapMarkerSymbol?
    let shift: CGFloat

    private static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

    @State private var position: MapCameraPosition
    @State private var appliedShift: CGFloat = 0

    // Centered south of the pin so it sits in the upper part of the map, clear of the dissolve.
    private var baseCenter: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinate.latitude - 0.001, longitude: coordinate.longitude)
    }

    init(
        coordinate: CLLocationCoordinate2D,
        markerTitle: String,
        markerTint: Color,
        markerSymbol: MapMarkerSymbol?,
        shift: CGFloat
    ) {
        self.coordinate = coordinate
        self.markerTitle = markerTitle
        self.markerTint = markerTint
        self.markerSymbol = markerSymbol
        self.shift = shift
        _position = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.latitude - 0.001,
                        longitude: coordinate.longitude
                    ),
                    span: Self.span
                )
            )
        )
    }

    var body: some View {
        GeometryReader { geometry in
            MapReader { proxy in
                Map(position: $position, interactionModes: []) {
                    switch markerSymbol {
                    case .system(let name):
                        Marker(markerTitle, systemImage: name, coordinate: coordinate)
                            .tint(markerTint)
                    case .custom(let name):
                        Marker(markerTitle, image: name, coordinate: coordinate)
                            .tint(markerTint)
                    case .resource(let resource):
                        Marker(coordinate: coordinate) {
                            Label(markerTitle, image: resource)
                        }
                        .tint(markerTint)
                    case nil:
                        Marker(markerTitle, coordinate: coordinate)
                            .tint(markerTint)
                    }
                }
                .mapStyle(.standard)
                .onChange(of: shift) { recenter(proxy, in: geometry.size) }
                .onChange(of: geometry.size) { recenter(proxy, in: geometry.size) }
                // The projection isn't available until the first camera settles.
                .onMapCameraChange(frequency: .onEnd) { _ in recenter(proxy, in: geometry.size) }
            }
        }
    }

    private func recenter(_ proxy: MapProxy, in size: CGSize) {
        guard shift != appliedShift, size.width > 0,
            let origin = proxy.convert(CGPoint(x: size.width / 2, y: size.height / 2), from: .local),
            let step = proxy.convert(CGPoint(x: size.width / 2 + 1, y: size.height / 2), from: .local)
        else { return }
        let degreesPerPoint = step.longitude - origin.longitude
        appliedShift = shift
        withAnimation(.smooth(duration: 0.25)) {
            position = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: baseCenter.latitude,
                        longitude: baseCenter.longitude - Double(shift) * degreesPerPoint
                    ),
                    span: Self.span
                )
            )
        }
    }
}

/// The symbol drawn inside a map marker.
public enum MapMarkerSymbol {
    /// An SF Symbol, by name.
    case system(String)
    /// A custom symbol or image in the main bundle's asset catalog, by name.
    case custom(String)
    /// A custom symbol or image from any bundle, such as a generated `ImageResource`.
    case resource(ImageResource)
}

private struct MapKey: Hashable {
    let latitude: Double
    let longitude: Double
}

#Preview {
    NavigationStack {
        MapBackdropScrollView(
            coordinate: CLLocationCoordinate2D(latitude: 35.0394, longitude: 135.7292),
            markerTitle: "Kinkaku-ji",
            markerTint: .pink,
            markerSymbol: .system("building.columns.fill")
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
