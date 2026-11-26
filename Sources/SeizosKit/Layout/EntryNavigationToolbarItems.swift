//
//  EntryNavigationToolbarItems.swift
//  SeizosKit
//

import SwiftUI

/// Previous/next chevron buttons for stepping through an ordered list of
/// entries from a detail view's toolbar.
///
/// Because this is `ToolbarContent` rather than a modifier, the host controls
/// where it sits by declaring it before or after its other toolbar items:
///
///     .toolbar {
///         EntryNavigationToolbarItems(
///             entries: allEntries,
///             selection: $selection,
///             current: entry,
///             placement: .topBarTrailing
///         )
///         ToolbarItem(placement: .topBarTrailing) { moreMenu }
///     }
///
/// By default the buttons only show when the list can't be used to pick an
/// entry: the split view is stacked, or its sidebar isn't visible (see
/// ``SwiftUI/EnvironmentValues/isSplitViewSidebarVisible``). Pass
/// `showsEntryNavigation` to override that.
public struct EntryNavigationToolbarItems<Entry: Identifiable>: ToolbarContent {
    @Environment(\.isSplitViewStacked) private var isSplitViewStacked
    @Environment(\.isSplitViewSidebarVisible) private var isSidebarVisible

    let entries: [Entry]
    @Binding var selection: Entry?
    let current: Entry
    let showsEntryNavigation: Bool?
    let placement: ToolbarItemPlacement
    let spacerAfter: Bool

    /// - Parameters:
    ///   - entries: The ordered entries to step through.
    ///   - selection: Updated to the neighboring entry when a button is tapped.
    ///   - current: The entry the detail view is showing.
    ///   - showsEntryNavigation: Forces the buttons on or off. `nil` lets
    ///     SeizosKit decide from the split view's layout.
    ///   - placement: Where the buttons go in the toolbar.
    ///   - spacerAfter: Adds a fixed spacer after the buttons (iOS 26 and
    ///     later) so they read as their own group.
    public init(
        entries: [Entry],
        selection: Binding<Entry?>,
        current: Entry,
        showsEntryNavigation: Bool? = nil,
        placement: ToolbarItemPlacement = .automatic,
        spacerAfter: Bool = true
    ) {
        self.entries = entries
        self._selection = selection
        self.current = current
        self.showsEntryNavigation = showsEntryNavigation
        self.placement = placement
        self.spacerAfter = spacerAfter
    }

    private var isShown: Bool {
        showsEntryNavigation ?? (isSplitViewStacked || !isSidebarVisible)
    }

    private var neighbors: EntryNeighbors<Entry> {
        EntryNeighbors(entries: entries, current: current)
    }

    @ToolbarContentBuilder
    public var body: some ToolbarContent {
        if isShown {
            ToolbarItemGroup(placement: placement) {
                let neighbors = neighbors
                Button {
                    if let previous = neighbors.previous {
                        selection = previous
                    }
                } label: {
                    Label(
                        String(
                            localized: "entryNavigation.previous",
                            bundle: .module
                        ),
                        systemImage: "chevron.up"
                    )
                }
                .disabled(neighbors.previous == nil)
                Button {
                    if let next = neighbors.next { selection = next }
                } label: {
                    Label(
                        String(
                            localized: "entryNavigation.next",
                            bundle: .module
                        ),
                        systemImage: "chevron.down"
                    )
                }
                .disabled(neighbors.next == nil)
            }
            #if os(iOS) || os(macOS)
                if spacerAfter {
                    EntryNavigationSpacer(placement: placement)
                }
            #endif
        }
    }
}

#if os(iOS) || os(macOS)
    /// `ToolbarSpacer` is iOS/macOS 26+ only, but the package supports older
    /// systems. It doesn't exist on watchOS or visionOS, so the call site skips it.
    private struct EntryNavigationSpacer: ToolbarContent {
        let placement: ToolbarItemPlacement

        @ToolbarContentBuilder
        var body: some ToolbarContent {
            if #available(iOS 26, macOS 26, *) {
                ToolbarSpacer(.fixed, placement: placement)
            }
        }
    }
#endif

/// The entries adjacent to `current`, looked up by `id`.
struct EntryNeighbors<Entry: Identifiable> {
    let previous: Entry?
    let next: Entry?

    init(entries: [Entry], current: Entry) {
        guard let index = entries.firstIndex(where: { $0.id == current.id })
        else {
            previous = nil
            next = nil
            return
        }
        previous = index > entries.startIndex ? entries[index - 1] : nil
        next = index + 1 < entries.endIndex ? entries[index + 1] : nil
    }
}
