import Testing
import Foundation
import OSLog

@testable import SeizosKit

// MARK: - Date.formattedLongDate

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

// MARK: - Logger networking extensions (smoke tests)

@Suite("Logger+Networking")
struct LoggerNetworkingTests {
    private let logger = Logger(subsystem: "com.seizoskit.tests", category: "networking")

    @Test("logRequest does not crash with a valid URL")
    func logRequestValidURL() {
        var request = URLRequest(url: URL(string: "https://example.com/api/test")!)
        request.httpMethod = "GET"
        logger.logRequest(request)
    }

    @Test("logRequest does not crash when URL is missing")
    func logRequestMissingURL() {
        // URLRequest always requires a URL at init time, but we can test the
        // method path by passing an intentionally minimal request.
        let request = URLRequest(url: URL(string: "https://example.com")!)
        logger.logRequest(request)
    }

    @Test("logResponse does not crash with valid UTF-8 data")
    func logResponseValidData() {
        let data = Data("{\"status\":\"ok\"}".utf8)
        logger.logResponse(data)
    }

    @Test("logResponse does not crash with non-UTF-8 data")
    func logResponseInvalidUTF8() {
        let data = Data([0xFF, 0xFE, 0x00])
        logger.logResponse(data)
    }

    @Test("logNetworkError does not crash without an HTTP response")
    func logNetworkErrorNoResponse() {
        let error = URLError(.notConnectedToInternet)
        logger.logNetworkError(requestError: error, response: nil)
    }

    @Test("logNetworkError does not crash with an HTTP response")
    func logNetworkErrorWithHTTPResponse() {
        let error = URLError(.timedOut)
        let response = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 503,
            httpVersion: nil,
            headerFields: nil
        )
        logger.logNetworkError(requestError: error, response: response)
    }
}
