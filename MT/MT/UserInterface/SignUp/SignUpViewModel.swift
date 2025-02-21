//
//  SignUpViewModel.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

typealias SignUpCommunication = RegistrationCommunication & AuthMeCommunication & GoogleAuthCommunication

class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var requestErrorMessage = ""
    @Published var didFailRegister: Bool = false

    let communication: SignUpCommunication
    var userRepository: UserRepository

    var registerSuccessful: Event?

    init(communication: SignUpCommunication, userRepository: UserRepository) {
        self.communication = communication
        self.userRepository = userRepository
    }

    func register() {
        if verifyMendatoryFields() {
            Task { @MainActor in
                do {
                    let loginResponse = try await communication.register(email: email,
                                                                         password: password)

                    userRepository.authToken = loginResponse

                    let profileResponse = try await communication.getMyProfile()

                    userRepository.user = profileResponse

                    registerSuccessful?()
                } catch {
                    didFailRegister = true
                    requestErrorMessage = error.customErrorMessage("Could not register this user")
                }
            }
        }
    }

    func googleRegister(token: String) {
        Task { @MainActor in
            do {
                let loginResponse = try await communication.googleAuth(token: token)

                userRepository.authToken = loginResponse

                let profileResponse = try await communication.getMyProfile()

                userRepository.user = profileResponse

                registerSuccessful?()
            } catch {
                didFailRegister = true
                requestErrorMessage = error.customErrorMessage("Could not register this user")
            }
        }
    }

    func verifyMendatoryFields() -> Bool {
        var areAllMendatoryFieldsChecked: Bool = false

        if !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword {
            areAllMendatoryFieldsChecked = true
        }
        return areAllMendatoryFieldsChecked
    }
}
