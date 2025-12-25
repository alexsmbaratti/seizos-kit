//
//  Logger+Networking.swift
//  SeizosKit
//
//  Created by Alex Baratti on 12/24/25.
//

import Foundation
import OSLog

public extension Logger {
    
    /// Logs a network request in a standardized format.
    func logRequest(_ request: URLRequest) {
        if let url = request.url {
            debug(
                "\(request.httpMethod ?? "Unknown method") \(url.absoluteString, privacy: .public)"
            )
        } else {
            error("Failed to retrieve URL from request")
        }
    }
    
    /// Logs raw network response data.
    func logResponse(_ data: Data) {
        if let responseString = String(data: data, encoding: .utf8) {
            debug("Response: \(responseString, privacy: .sensitive)")
        } else {
            error("Failed to convert response data to string")
        }
    }
    
    /// Logs a network error and optional HTTP response for a failed network request.
    func logNetworkError(requestError: Error, response: URLResponse?) {
        error(
            "Network request failed with error: \(requestError.localizedDescription, privacy: .sensitive)"
        )
        
        if let httpResponse = response as? HTTPURLResponse {
            error("HTTP Status Code: \(httpResponse.statusCode)")
        }
    }
}
