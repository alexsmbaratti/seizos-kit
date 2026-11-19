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
    @State private var hasMeasured = false

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
                    shift: centerShift,
                    animatesShift: hasMeasured,
                    bottomInset: overlap - contentOffset
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
                        // The first measurement happens as the map appears, so it shouldn't slide.
                        // Later ones do; the map animates them itself.
                        if !hasMeasured {
                            Task { @MainActor in hasMeasured = true }
                        }
                    }
            }
        }
    }
}

/// A non-interactive map whose center sits `shift` points right of the container's center.
///
/// The camera stays fixed on the marker, which sits at the center of the map view. The view is
/// `2 * shift` points wider than the container and starts at its leading edge, so its center, and
/// the marker with it, lands in the part that isn't covered by a sidebar. Apple's logo and Legal
/// link sit at the bottom leading corner, which is behind the sidebar while it is open.
///
/// When `shift` changes, the map view is resized right away, which would make the marker jump.
/// An offset cancels the jump and then animates to zero, so the map glides instead.
private struct OffsetMap: View {
    let coordinate: CLLocationCoordinate2D
    let markerTitle: String
    let markerTint: Color
    let markerSymbol: MapMarkerSymbol?
    let shift: CGFloat
    /// Whether a change to `shift` slides the map. Off until the first measurement has settled.
    let animatesShift: Bool
    /// How much of the map's bottom edge is reserved so Apple's logo and Legal link sit just above
    /// the content's top edge.
    let bottomInset: CGFloat

    /// The shift the map has finished sliding to. Lags `shift` while sliding.
    @State private var settledShift: CGFloat = 0
    @State private var hasSettled = false

    var body: some View {
        GeometryReader { geometry in
            map
                .safeAreaPadding(.bottom, bottomInset)
                .frame(width: max(1, geometry.size.width + 2 * shift), height: geometry.size.height)
                .offset(x: (hasSettled ? settledShift : shift) - shift)
                // Resizing the map and cancelling its jump with the offset must both happen at
                // once, whatever animation is in flight. Only the slide back to zero animates.
                .transaction(value: shift) { $0.animation = nil }
        }
        .clipped()
        .onChange(of: shift, initial: true) { _, newShift in
            if animatesShift && hasSettled {
                withAnimation(.smooth(duration: 0.25)) { settledShift = newShift }
            } else {
                settledShift = newShift
                hasSettled = true
            }
        }
    }

    private var map: some View {
        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    // Centered just north of the pin, since the marker's glyph extends above its
                    // coordinate, so the pin looks vertically centered in the usable area.
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.latitude + 0.0002,
                        longitude: coordinate.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.0033,
                        longitudeDelta: 0.0033
                    )
                )
            ),
            interactionModes: []
        ) {
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
