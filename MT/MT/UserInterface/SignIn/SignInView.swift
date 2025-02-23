//
//  SignInView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

//import SwiftUI
//import GoogleSignIn
//
//struct SignInView: View {
//    @StateObject var viewModel: SignInViewModel
//
//    var body: some View {
//        ZStack {
//            Color(.systemBackground).opacity(0.95)
//                .ignoresSafeArea()
//            title
//
//            VStack(spacing: 24) {
//                VStack(spacing: 8) {
//                    TypographyText(text: "Welcome", typography: .mediumHeading)
//                        .foregroundStyle(.black.opacity(0.8))
//                }
//                emailField
//                passwordField
//
//                VStack(spacing: 12) {
//                    continueButton
//                    guestButton
//                }
//
//                TypographyText(text: "Or log in with:", typography: .body2)
//                    .foregroundStyle(.black.opacity(0.8))
//                    .multilineTextAlignment(.center)
//
//                VStack(spacing: 12) {
//                    googleButton
//                    appleButton
//                }
//
//                signUpText
//            }
//            .padding(16)
//            .background {
//                RoundedRectangle(cornerRadius: 6)
//                    .foregroundStyle(Color(.secondarySystemBackground).opacity(0.9))
//            }
//            .padding(16)
//        }
//        .ignoresSafeArea(.keyboard, edges: .bottom)
//        .alert("Login failed", isPresented: $viewModel.didFailLogin) {
//            Button("OK") {}
//        } message: {
//            TypographyText(text: viewModel.requestErrorMessage, typography: Typography.body3)
//        }
//        .navigationBarBackButtonHidden()
//    }
//
//    private var title: some View {
//        VStack {
//            TypographyText(text: "ReportIt", typography: .bigHeading)
//                .foregroundStyle(.black.opacity(0.8))
//                .padding()
//            Spacer()
//        }
////        .padding(.top, 34)
//    }
//
//    private var continueButton: some View {
//        CustomButton(action: viewModel.login, text: "Continue")
//    }
//
//    private var emailField: some View {
//        TextField("Email address", text: $viewModel.email)
//            .keyboardType(.emailAddress)
//            .autocorrectionDisabled()
//            .textInputAutocapitalization(.never)
//    }
//
//    private var passwordField: some View {
//        SecureField("Password", text: $viewModel.password)
//    }
//
//    private var resetPasswordText: some View {
//        HStack(spacing: 4) {
//            TypographyText(text: "I forgot my password.", typography: .body)
//                .foregroundStyle(.black.opacity(0.8))
//            Button(action: {
//                //TODO: Update logic later
//            }) {
//                TypographyText(text: "Reset here", typography: .body)
//                    .foregroundStyle(.black.opacity(0.8))
//                    .underline()
//            }
//        }
//    }
//
//    private var googleButton: some View {
//        Button {
//            handleSignupButton()
//        } label: {
//            HStack(spacing: 4) {
//                Spacer()
//
//                Image(.googleIcon)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//
//                TypographyText(text: "Sign in with Google", typography: .body2)
//                    .foregroundStyle(Color(.label).opacity(0.9))
//                    .frame(height: 24)
//
//                Spacer()
//            }
//            .frame(height: 48)
//            .overlay {
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.black).opacity(0.7), lineWidth: 1)
//            }
//            .contentShape(Rectangle())
//        }
//    }
//
//    private var appleButton: some View {
//        Button {
//            //TODO: Apple login
//        } label: {
//            HStack(spacing: 12) {
//                Spacer()
//
//                Image(systemName: "apple.logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 28)
//                    .foregroundStyle(.black.opacity(0.8))
//
//                TypographyText(text: "Sign in with Apple", typography: .body2)
//                    .foregroundStyle(Color(.label).opacity(0.9))
//                    .frame(height: 24)
//
//                Spacer()
//            }
//            .padding(8)
//            .frame(height: 48)
//            .overlay {
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.black).opacity(0.7), lineWidth: 1)
//            }
//            .contentShape(Rectangle())
//        }
//    }
//
//    private var guestButton: some View {
//        Button {
//            viewModel.continueAsGuest()
//        } label: {
//            HStack(spacing: 12) {
//                Spacer()
//
//                TypographyText(text: "Continue as guest", typography: .body2)
//                    .foregroundStyle(Color(.systemBlue))
//                    .frame(height: 24)
//
//                Spacer()
//            }
//            .padding(8)
//            .frame(height: 48)
//            .overlay {
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color(.black).opacity(0.7), lineWidth: 1)
//            }
//            .contentShape(Rectangle())
//        }
//    }
//
//    func handleSignupButton() {
//        if let rootViewController = getRootViewController() {
//            GIDSignIn.sharedInstance.signIn(
//                withPresenting: rootViewController
//            ) { result, error in
//                guard let result else {
//                    return
//                }
//                if let token = result.user.idToken?.tokenString {
//                    viewModel.googleLogin(token: token)
//                }
//            }
//        }
//    }
//
//    func getRootViewController() -> UIViewController? {
//        guard let scene = UIApplication.shared.connectedScenes.first as?
//                UIWindowScene,
//              let rootViewController = scene.windows.first?.rootViewController else {
//            return nil
//        }
//        return getVisibleViewController(from: rootViewController)
//    }
//
//    private func getVisibleViewController(from vc: UIViewController) -> UIViewController {
//        if let nav = vc as? UINavigationController {
//            return getVisibleViewController(from: nav.visibleViewController!)
//        }
//        if let tab = vc as? UITabBarController {
//            return getVisibleViewController(from: tab.selectedViewController!)
//        }
//        if let presented = vc.presentedViewController {
//            return getVisibleViewController(from: presented)
//        }
//        return vc
//    }
//
//    private var signUpText: some View {
//        HStack(spacing: 4) {
//            TypographyText(text: "Do you have an account?", typography: .body)
//                .foregroundStyle(.black.opacity(0.8))
//            Button(action: { viewModel.goToSignUp?() }) {
//                TypographyText(text: "Sign up", typography: .body)
//                    .foregroundStyle(.black.opacity(0.8))
//                    .underline()
//            }
//        }
//    }
//}

//
//  SignInView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel

    var body: some View {
        ZStack {
            Color(.systemBackground).opacity(0.95)
                .ignoresSafeArea()
            title

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    TypographyText(text: "Welcome", typography: .mediumHeading)
                        .foregroundStyle(.black.opacity(0.8))
                }
                emailField
                passwordField

                VStack(spacing: 12) {
                    continueButton
                    guestButton
                }

                TypographyText(text: "Or log in with:", typography: .body2)
                    .foregroundStyle(.black.opacity(0.8))
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    googleButton
                    appleButton
                }

                signUpText
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(Color(.secondarySystemBackground).opacity(0.9))
            }
            .padding(16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert("Login failed", isPresented: $viewModel.didFailLogin) {
            Button("OK") {}
        } message: {
            TypographyText(text: viewModel.requestErrorMessage, typography: Typography.body3)
        }
        .navigationBarBackButtonHidden()
    }

    private var title: some View {
        VStack {
            TypographyText(text: "ReportIt", typography: .bigHeading)
                .foregroundStyle(.black.opacity(0.8))
                .padding()
            Spacer()
        }
    }

    private var continueButton: some View {
        CustomButton(action: viewModel.login, text: "Continue")
    }

    private var emailField: some View {
        TextField("Email address", text: $viewModel.email)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }

    private var passwordField: some View {
        SecureField("Password", text: $viewModel.password)
    }

    private var googleButton: some View {
        Button {
            handleGoogleSignup()
        } label: {
            HStack(spacing: 4) {
                Spacer()
                Image(.googleIcon)
                    .resizable()
                    .frame(width: 40, height: 40)

                TypographyText(text: "Sign in with Google", typography: .body2)
                    .foregroundStyle(Color(.label).opacity(0.9))
                    .frame(height: 24)

                Spacer()
            }
            .frame(height: 48)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.black).opacity(0.7), lineWidth: 1)
            }
            .contentShape(Rectangle())
        }
    }

    private var appleButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    handleAppleSignIn(authResults)
                case .failure(let error):
                    print("Sign in with Apple failed: \(error.localizedDescription)")
                }
            }
        )
        .frame(height: 48)
        .signInWithAppleButtonStyle(.black)
    }

    private var guestButton: some View {
        Button {
            viewModel.continueAsGuest()
        } label: {
            HStack(spacing: 12) {
                Spacer()
                TypographyText(text: "Continue as guest", typography: .body2)
                    .foregroundStyle(Color(.systemBlue))
                    .frame(height: 24)
                Spacer()
            }
            .padding(8)
            .frame(height: 48)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.black).opacity(0.7), lineWidth: 1)
            }
            .contentShape(Rectangle())
        }
    }

    func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as?
                UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return getVisibleViewController(from: rootViewController)
    }

    private func getVisibleViewController(from vc: UIViewController) -> UIViewController {
        if let nav = vc as? UINavigationController {
            return getVisibleViewController(from: nav.visibleViewController!)
        }
        if let tab = vc as? UITabBarController {
            return getVisibleViewController(from: tab.selectedViewController!)
        }
        if let presented = vc.presentedViewController {
            return getVisibleViewController(from: presented)
        }
        return vc
    }


    func handleGoogleSignup() {
        if let rootViewController = getRootViewController() {
            GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController
            ) { result, error in
                guard let result else {
                    return
                }
                if let token = result.user.idToken?.tokenString {
                    viewModel.googleLogin(token: token)
                }
            }
        }
    }

    func handleAppleSignIn(_ authResults: ASAuthorization) {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            if let tokenData = appleIDCredential.identityToken,
               let tokenString = String(data: tokenData, encoding: .utf8) {
                print("### tokenString: \(tokenString)")
//                viewModel.appleLogin(token: tokenString)
            }
        }
    }

    private var signUpText: some View {
        HStack(spacing: 4) {
            TypographyText(text: "Do you have an account?", typography: .body)
                .foregroundStyle(.black.opacity(0.8))
            Button(action: { viewModel.goToSignUp?() }) {
                TypographyText(text: "Sign up", typography: .body)
                    .foregroundStyle(.black.opacity(0.8))
                    .underline()
            }
        }
    }
}
