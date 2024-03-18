//
//  APIClient.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation
import Network

/**
 * A client for sending events to the AppFit API.
 * - Parameters:
 *   - apiKey: The API key provided by AppFit.
 */
internal struct APIClient {
    /// The JSON Encoder
    private let encoder: JSONEncoder

    /// The API key provided by AppFit.
    internal let apiKey: String

    /// The base URL of the request
    internal let baseUrl: URL

    /// Network Monitoring Queue
    let queue = DispatchQueue(label: "NetworkMonitor")

    /// Network Monitor
    let monitor = NWPathMonitor()

    /** Initializes a new APIClient with the provided API key.
     * - Parameters:
     *   - apiKey: The API key provided by AppFit.
     *   - baseUrl: The base for the API requests
     */
    internal init(
        apiKey: String,
        baseUrl: URL? = nil
    ) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl ?? URL(string: "https://api.appfit.io")!

        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601

        self.monitor.pathUpdateHandler = { path in
            switch path.status {
            case .satisfied: print("Internet connection is available.")
            case .unsatisfied: print("Internet connection is not available.")
            case .requiresConnection: print("Internet connection is not available. Asking for connection.")
            @unknown default: print("Unknown state of the internet connection")
            }
        }
        self.monitor.start(queue: self.queue)
    }

    /** Sends an event to the AppFit API.
     * - Parameters:
     *   - event: The event to send.
     */
    internal func sendEvent(_ event: RawMetricEvent) async throws -> Bool {
        guard self.monitor.currentPath.status == .satisfied else {
            return false
        }

        let url = URL(string: "/metric-events", relativeTo: self.baseUrl)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(self.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        do {
            request.httpBody = try self.encoder.encode(event)
        } catch {
            print("Error encoding payload: \(error)")
            return false
        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending event: \(error)")
                    continuation.resume(returning: false)
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    print("Event sent error")
                    continuation.resume(returning: false)
                    return
                }
                guard (200..<300).contains(response.statusCode) else {
                    print("Event sent error")
                    continuation.resume(returning: false)
                    return
                }
                continuation.resume(returning: true)
            }
            task.resume()
        }
    }
}
