//
//  Test.swift
//  SeizosKit
//
//  Created by Alex Baratti on 6/17/26.
//

import Testing
import OSLog

@testable import SeizosKit

@Suite("Logger+Networking")
struct LoggerNetworkingTests {
    private let logger = Logger(subsystem: "com.seizoskit.tests", category: "networking")

    @Test("logRequest does not crash with a valid URL")
    func logRequestValidURL() {
        var request = URLRequest(url: URL(string: "https://example.com/api/test")!)
        request.httpMethod = "GET"
        logger.logRequest(request)
    }

    @Test("logRequest does not crash when URL is cleared after construction")
    func logRequestNilURL() {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.url = nil
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
