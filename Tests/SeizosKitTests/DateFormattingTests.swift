import Testing
import Foundation

@testable import SeizosKit

@Suite("Date.formattedLongDate")
struct DateFormattingTests {
    // A fixed date: January 1, 2000 at midnight UTC (Unix timestamp 946684800)
    private let epoch2000 = Date(timeIntervalSince1970: 946_684_800)

    @Test("Returns a non-empty string")
    func returnsNonEmptyString() {
        let result = epoch2000.formattedLongDate(timeZone: .gmt)
        #expect(!result.isEmpty)
    }

    @Test("Formats January 1 2000 correctly in GMT")
    func formatsKnownDateInGMT() {
        let result = epoch2000.formattedLongDate(timeZone: .gmt)
        #expect(result == "January 1, 2000")
    }

    @Test("Respects the provided time zone")
    func respectsTimeZone() {
        // UTC-5 should shift midnight UTC to the previous day (December 31, 1999)
        let eastern = TimeZone(secondsFromGMT: -5 * 3600)!
        let result = epoch2000.formattedLongDate(timeZone: eastern)
        #expect(result == "December 31, 1999")
    }

    @Test("Defaults to the current time zone without crashing")
    func defaultTimeZoneDoesNotCrash() {
        let result = epoch2000.formattedLongDate()
        #expect(!result.isEmpty)
    }
}
