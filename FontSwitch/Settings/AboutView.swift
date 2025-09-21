//
// AboutView.swift
// FontSwitch
// https://github.com/JPToroDev/FontSwitch
// See LICENSE for license information.
// © 2024 J.P. Toro
//

import SwiftUI

struct AboutView: View {
    @AppStorage(K.Default.subscribedToNewsletter) private var hasSubscribed = false
    @State private var email = ""
    @State private var isShowingErrorAlert = false
    @State private var subscriptionError: NewsletterSubscriptionError?

    private let year: Int = {
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: .now).year
        return year ?? 2024
    }()

    private let versionNumber: String = {
        let mainBundle = Bundle.main
        let version = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        return version as? String ?? "1.0"
    }()

    private let headingGradient: LinearGradient = {
        .init(colors: [.blue, .pink], startPoint: .leading, endPoint: .trailing)
    }()

    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                appIcon
                appDetails
            }

            Divider()
            newsletterSignUp
        }
        .alert(isPresented: $isShowingErrorAlert, error: subscriptionError) { _ in
        } message: { error in
            Text(error.recoverySuggestion ?? "Please try again later.")
        }
    }

    private var appIcon: some View {
        Image(.internalIcon)
            .interpolation(.high)
            .resizable()
            .frame(width: 95, height: 95)
            .shadow(color: .black.opacity(0.15), radius: 1.5)
    }

    private var appDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Font Switch")
                .fontWeight(.bold)
                .font(.title2)

            Text("Version \(versionNumber)")
                .font(.system(.body).smallCaps())
                .foregroundStyle(.secondary)
                .padding(.bottom, 3)

            Text("© \(year, format: .number.grouping(.never)) [J.P. Toro](https://jptoro.dev)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var newsletterSignUp: some View {
        HStack {
            Text("Newsletter")
                .font(.title3.smallCaps())
                .fontWeight(.bold)
                .foregroundStyle(headingGradient)

            if hasSubscribed {
                Text("Subscribed! 🎉")
            } else {
                TextField("Email", text: $email, prompt: Text("Join J.P. Toro’s Newsletter"))
                    .textFieldStyle(.roundedBorder)
                Button("Send", systemImage: "paperplane", action: subscribe)
                    .labelStyle(.iconOnly)
                    .disabled(email.isEmpty)
            }
        }
    }

    // MARK: - METHODS

    private func subscribe() {
        Task {
            do {
                try await NewsletterService.subscribe(email: email)
                hasSubscribed = true
            } catch let error as NewsletterSubscriptionError {
                subscriptionError = error
                isShowingErrorAlert = true
            }
            email = ""
        }
    }
}
