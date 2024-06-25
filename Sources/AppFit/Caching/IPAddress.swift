//
//  IPAddress.swift
//
//
//  Created by Anthony Castelli on 6/25/24.
//

import Foundation

internal actor IPAddress {
    var ipAddress: String?
    var lastUpdatedAt: Date

    var isExpired: Bool {
        // Determine if the IP address is expired
        // If the lastYpdatedAt is greater than 1 hour, then it's expired
        self.ipAddress == nil || self.lastUpdatedAt.distance(to: Date()) > 3600
    }

    init(ipAddress: String? = nil, lastUpdatedAt: Date = Date()) {
        self.ipAddress = ipAddress
        self.lastUpdatedAt = lastUpdatedAt
    }

    func fetchIpAddress() async throws -> String? {
        guard self.isExpired else { return self.ipAddress }

        var request = URLRequest(url: URL(string: "https://api.ipgeolocation.io/getip")!)
        request.httpMethod = "GET"
        
        let data = try await self.send(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
        let ip = json?["ip"] as? String

        self.ipAddress = ip
        self.lastUpdatedAt = Date()

        return ip
    }

    /**
     * Performs the network request
     */
    private func send(_ request: URLRequest) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
                    continuation.resume(throwing: AppFitError.networkRequestFailed)
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: AppFitError.networkRequestFailed)
                    return
                }
                guard (200..<300).contains(response.statusCode) else {
                    continuation.resume(throwing: AppFitError.networkRequestFailed)
                    return
                }
                guard let data else {
                    continuation.resume(throwing: AppFitError.networkRequestFailed)
                    return
                }
                continuation.resume(returning: data)
            }
            task.resume()
        }
    }
}
