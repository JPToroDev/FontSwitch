//
// NewsletterSubscriptionError.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import Foundation

enum NewsletterSubscriptionError: LocalizedError {
    case invalidURL
    case invalidParameters
    case networkError(any Error)
    case invalidResponse
    case serverError(Int, String?)
    case timeout
    case unauthorized
    case emailAlreadySubscribed
    case unknown(any Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidParameters:
            "Invalid Parameters"
        case .networkError:
            "Network Error"
        case .invalidResponse:
            "Invalid Response"
        case .serverError(let code, _):
            "Server Error (\(code))"
        case .timeout:
            "Request Timeout"
        case .unauthorized:
            "Unauthorized"
        case .emailAlreadySubscribed:
            "Already Subscribed"
        case .unknown:
            "Unknown Error"
        }
    }

    var failureReason: String? {
        switch self {
        case .invalidURL:
            "The newsletter service URL is malformed."
        case .invalidParameters:
            "Failed to process your subscription request."
        case .networkError(let error):
            "Network request failed: \(error.localizedDescription)"
        case .invalidResponse:
            "The server response was invalid or corrupted."
        case .serverError(let code, let message):
            message ?? "The newsletter service returned an error with status code \(code)."
        case .timeout:
            "The subscription request took too long to complete."
        case .unauthorized:
            "There was an authentication issue with the newsletter service."
        case .emailAlreadySubscribed:
            "This email address is already subscribed to our newsletter."
        case .unknown(let error):
            "An unexpected error occurred: \(error.localizedDescription)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            "Please contact support."
        case .invalidParameters:
            "Please verify your email address and try again."
        case .networkError:
            "Check your internet connection and try again."
        case .invalidResponse:
            "Please try again later."
        case .serverError:
            "Please try again later or contact support."
        case .timeout:
            "Check your connection and try again."
        case .unauthorized:
            "Please try again or contact support if the issue persists."
        case .emailAlreadySubscribed:
            "You're all set! Check your inbox for our latest newsletter."
        case .unknown:
            "Please try again later."
        }
    }
}
