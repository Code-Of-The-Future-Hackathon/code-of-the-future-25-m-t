//
//  SignInViewModel.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import Foundation

class SignInViewModel: ObservableObject {
    var goToSignUp: Event?
    var goToResetPassword: Event?
    var loginSuccessful: Event?
}
