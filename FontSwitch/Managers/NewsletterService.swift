//
// NewsletterService.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import Foundation

enum NewsletterService {
    static func subscribe(email: String) async throws(NewsletterSubscriptionError) {
        let request = try createSubscriptionRequest(email: email)
        let (data, response) = try await performRequest(request)
        try handleResponse(data: data, response: response)
    }

    private static func createSubscriptionRequest(
        email: String
    ) throws(NewsletterSubscriptionError) -> URLRequest {
        let token = "myToken"
        let listID = 0000
        let url = "https://api.sendfox.com/contacts"

        guard let serviceUrl = URL(string: url) else {
            throw .invalidURL
        }

        let parameters: [String: Any] = ["email": email, "lists": listID]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            throw .invalidParameters
        }

        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        request.httpBody = httpBody

        return request
    }

    private static func performRequest(
        _ request: URLRequest
    ) async throws(NewsletterSubscriptionError) -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: request)
        } catch {
            if error.localizedDescription.contains("timeout") ||
               error.localizedDescription.contains("timed out") {
                throw .timeout
            } else {
                throw .networkError(error)
            }
        }
    }

    private static func handleResponse(
        data: Data,
        response: URLResponse
    ) throws(NewsletterSubscriptionError) {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .invalidResponse
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            break
        case 400:
            throw .invalidParameters
        case 401, 403:
            throw .unauthorized
        case 409:
            throw .emailAlreadySubscribed
        case 408:
            throw .timeout
        default:
            let errorMessage = String(data: data, encoding: .utf8)
            throw .serverError(httpResponse.statusCode, errorMessage)
        }
    }
}
