//
//  APIClient.swift
//  
//
//  Created by Anthony Castelli on 3/14/24.
//

import Foundation

/** 
 * A client for sending events to the AppFit API.
 * - Parameters:
 *   - apiKey: The API key provided by AppFit.
 */
internal struct APIClient {
    /// The JSON Encoder
    private let encoder = JSONEncoder()

    /// The API key provided by AppFit.
    internal let apiKey: String

    /** Initializes a new APIClient with the provided API key.
     * - Parameters:
     *   - apiKey: The API key provided by AppFit.
     */
    internal init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /** Sends an event to the AppFit API.
     * - Parameters:
     *   - event: The event to send.
     */
    internal func sendEvent(_ event: RawMetricEvent) async throws -> Bool {
        let url = URL(string: "https://api.appfit.io/metric-events")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(self.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? self.encoder.encode(event)

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
