//
//  ReportProblemView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct ReportProblemView: View {
    @StateObject private var viewModel = ReportProblemViewModel()

    var body: some View {
        VStack(spacing: 16) {
            TypographyText(text: "Report problem", typography: .bigHeading)

            TextField("Title*", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Description (Optional)", text: $viewModel.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Spacer()

            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()

//            if viewModel.isUploadEnabled {
                Button(action: {
                    viewModel.isShowingCamera = true
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text(viewModel.image == nil ? "Upload Image" : "Retake Image")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
//            }

            Button(action: {
                viewModel.submitReport()
            }) {
                Text("Submit")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isSubmitDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(viewModel.isSubmitDisabled)
            .padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.isShowingCamera) {
            CameraView(image: $viewModel.image)
        }
        .navigationBarBackButtonHidden()
        .padding(.top, 16)
    }
}

#Preview {
    ReportProblemView()
}
