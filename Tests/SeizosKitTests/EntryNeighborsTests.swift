import Testing

@testable import SeizosKit

@Suite("EntryNeighbors")
struct EntryNeighborsTests {
    private struct Item: Identifiable, Equatable {
        let id: Int
    }

    private let items = (1...3).map(Item.init)

    @Test func middleEntryHasBothNeighbors() {
        let n = EntryNeighbors(entries: items, current: items[1])
        #expect(n.previous == items[0])
        #expect(n.next == items[2])
    }

    @Test func firstEntryHasNoPrevious() {
        let n = EntryNeighbors(entries: items, current: items[0])
        #expect(n.previous == nil)
        #expect(n.next == items[1])
    }

    @Test func lastEntryHasNoNext() {
        let n = EntryNeighbors(entries: items, current: items[2])
        #expect(n.previous == items[1])
        #expect(n.next == nil)
    }

    @Test func missingEntryHasNoNeighbors() {
        let n = EntryNeighbors(entries: items, current: Item(id: 99))
        #expect(n.previous == nil)
        #expect(n.next == nil)
    }
}
