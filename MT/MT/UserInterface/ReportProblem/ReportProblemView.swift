//
//  ReportProblemView.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

struct ReportProblemView: View {
    @StateObject var viewModel: ReportProblemViewModel

    var heading: some View {
        ZStack {
            TypographyText(text: "Report problem", typography: .bigHeading)

            HStack {
                Button(action: viewModel.goBack) {
                    Image(systemName: "arrow.backward")
                }

                Spacer()
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            heading

            TextField("Title*", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Description (Optional)", text: $viewModel.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Spacer()

            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
            }

            Spacer()

            if viewModel.supportsImages {
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
            }

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
        }
        .sheet(isPresented: $viewModel.isShowingCamera) {
            CameraView(image: $viewModel.image)
        }
        .navigationBarBackButtonHidden()
        .padding(.top, 16)
        .padding(.horizontal)
    }
}

// #Preview {
//    ReportProblemView(viewModel: ReportProblemViewModel(communication: <#any ReportIssueCommunication#>, issueType: IssueType(id: 1, title: "Test"), goBack: {}))
// }
