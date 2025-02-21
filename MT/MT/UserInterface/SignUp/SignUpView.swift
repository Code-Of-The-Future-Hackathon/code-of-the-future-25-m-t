//
//  SignUpView.swift
//  MT
//
//  Created by Mihail Kolev on 21/02/2025.
//

import SwiftUI
import GoogleSignIn

struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel
    
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
                
                passwordFields
                continueButton
                
                TypographyText(text: "Or sign up with:", typography: .body2)
                    .foregroundStyle(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                mediaIcons
                    .padding(.bottom, 50)
                
            }
            .padding(EdgeInsets(top: 16,
                                leading: 24,
                                bottom: 16,
                                trailing: 24))
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(Color(.secondarySystemBackground).opacity(0.9))
            }
            .padding(16)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .alert("Register failed", isPresented: $viewModel.didFailRegister) {
            Button("OK") {}
        } message: {
            TypographyText(text: viewModel.requestErrorMessage, typography: Typography.body3)
        }
//        .navigationBarBackButtonHidden()
    }
    
    func handleSignupButton() {
        if let rootViewController = getRootViewController() {
            GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController
            ) { result, error in
                guard let result else {
                    return
                }
                if let token = result.user.idToken?.tokenString {
                    viewModel.googleRegister(token: token)
                }
            }
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
    
    private var title: some View {
        VStack {
            TypographyText(text: "M&T", typography: .bigHeading)
                .foregroundStyle(.black.opacity(0.8))
            Spacer()
        }
        .padding(.top, 34)
    }

    private var emailField: some View {
        TextField("Email address", text: $viewModel.email)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }

    private var passwordFields: some View {
        VStack(spacing: 24) {
            SecureField("Password", text: $viewModel.password)

            SecureField("Repeat password", text: $viewModel.confirmPassword)
        }
    }

    private var mediaIcons: some View {
        HStack(spacing: 24) {
            Button(action: { }) {
                Image(.appleIcon)
                    .resizable()
                    .frame(width: 40, height: 40)
            }

            Button(action: handleSignupButton) {
                Image(.googleIcon)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
    }

    private var continueButton: some View {
        CustomButton(action: viewModel.register,
                   text: "CONTINUE")
            .padding(.horizontal, 8)
    }

}
