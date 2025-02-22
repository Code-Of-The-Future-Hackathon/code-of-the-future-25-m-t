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

                VStack(spacing: 12) {
                    continueButton
                    guestButton
                }

                TypographyText(text: "Or sign up with:", typography: .body2)
                    .foregroundStyle(.black.opacity(0.8))
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    googleButton
                    appleButton
                }
                
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
        .navigationBarBackButtonHidden()
    }

    private var googleButton: some View {
        Button {
            handleSignupButton()
        } label: {
            HStack(spacing: 4) {
                Spacer()

                Image(.googleIcon)
                    .resizable()
                    .frame(width: 40, height: 40)

                TypographyText(text: "Sign up with Google", typography: .body2)
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
        Button {
            //TODO: Apple login
        } label: {
            HStack(spacing: 12) {
                Spacer()

                Image(systemName: "apple.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 28)
                    .foregroundStyle(.black.opacity(0.8))

                TypographyText(text: "Sign up with Apple", typography: .body2)
                    .foregroundStyle(Color(.label).opacity(0.9))
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
            ZStack {
                TypographyText(text: "ReportIt", typography: .bigHeading)
                    .foregroundStyle(.black.opacity(0.8))
                    .padding()
                HStack {
                    Button(action: { viewModel.goBack?() }) {
                        Image(systemName: "arrow.backward")
                    }
                    
                    Spacer()
                }
                .padding()
            }
            Spacer()
        }
//        .padding(.top, 34)
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
                   text: "Continue")
    }

}
