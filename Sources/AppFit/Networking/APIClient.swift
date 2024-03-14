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
    internal func sendEvent(_ event: RawMetricEvent, completed: @escaping @Sendable (Bool) -> Void) {
        let url = URL(string: "https://api.appfit.io/v1/metric")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(event)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending event: \(error)")
                completed(false)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Event sent error")
                completed(false)
                return
            }
            guard (200..<300).contains(response.statusCode) else {
                print("Event sent error")
                completed(false)
                return
            }
            completed(true)
        }
        task.resume()
    }
}
