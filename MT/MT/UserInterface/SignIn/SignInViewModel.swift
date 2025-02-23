//
//  SignInViewModel.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

typealias SignInCommunication = LoginCommunication & AuthMeCommunication & GoogleAuthCommunication & ContinueAsGuestCommunication & AppleAuthCommunication

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var requestErrorMessage = ""
    @Published var didFailLogin: Bool = false

    let communication: SignInCommunication
    var userRepository: UserRepository

    var goToSignUp: Event?
    var goToResetPassword: Event?
    var loginSuccessful: Event?

    init(communication: SignInCommunication, userRepository: UserRepository) {
        self.communication = communication
        self.userRepository = userRepository
    }

    func login() {
        if verifyMendatoryFields() {
            Task { @MainActor in
                do {
                    let loginResponse = try await communication.login(email: email,
                                                                      password: password)

                    userRepository.authToken = loginResponse

                    let profileResponse = try await communication.getMyProfile()

                    userRepository.user = profileResponse

                    loginSuccessful?()
                } catch {
                    didFailLogin = true
                    requestErrorMessage = error.customErrorMessage("Could not login this user")
                }
            }
        }
    }

    func googleLogin(token: String) {
        Task { @MainActor in
            do {
                let loginResponse = try await communication.googleAuth(token: token)

                userRepository.authToken = loginResponse

                let profileResponse = try await communication.getMyProfile()

                userRepository.user = profileResponse

                loginSuccessful?()
            } catch {
                didFailLogin = true
                requestErrorMessage = error.customErrorMessage("Could not login this user")
            }
        }
    }

    func appleLogin(token: String) {
        Task { @MainActor in
            do {
                let loginResponse = try await communication.appleAuth(token: token)
                userRepository.authToken = loginResponse
                let profileResponse = try await communication.getMyProfile()
                userRepository.user = profileResponse
                loginSuccessful?()
            } catch {
                didFailLogin = true
                requestErrorMessage = error.customErrorMessage("Could not login this user")
            }
        }
    }

    func verifyMendatoryFields() -> Bool {
        var areAllMendatoryFieldsChecked: Bool = false

        if !email.isEmpty && !password.isEmpty {
            areAllMendatoryFieldsChecked = true
        }
        return areAllMendatoryFieldsChecked
    }

    func continueAsGuest() {
        Task { @MainActor in
            do {
                let loginResponse = try await communication.continueAsGuest()

                userRepository.authToken = loginResponse

                let profileResponse = try await communication.getMyProfile()

                userRepository.user = profileResponse

                loginSuccessful?()
            } catch {
                didFailLogin = true
                requestErrorMessage = error.customErrorMessage("Could not login this user")
            }
        }
    }
}
