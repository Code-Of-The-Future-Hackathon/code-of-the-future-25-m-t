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
        ZStack {
            Color(.white).opacity(0.95)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                heading
                
                ScrollView {
                    TextField("Title*", text: $viewModel.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextEditor(text: $viewModel.description)
                            .frame(height: 150)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
                            .foregroundColor(.primary)
                            .font(.body)
                            .overlay {
                                VStack {
                                    HStack {
                                        if viewModel.description.isEmpty {
                                            Text("Description (Optional)")
                                                .foregroundColor(.gray)
                                                .padding(.leading, 12)
                                                .padding(.top, 16)
                                                .font(.body)
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(10)
                    } else {
                        Spacer()
                            .frame(height: 250)
                    }
                }
            }

            ZStack {
                VStack {
                    Spacer()
                    Color.white
                        .frame(height: 130)
                        .ignoresSafeArea()
                }
                VStack {
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
            }
        }
        .sheet(isPresented: $viewModel.isShowingCamera) {
            CameraView(image: $viewModel.image)
                .ignoresSafeArea()
        }
        .onTapGesture {
            closeKeyboard()
        }
        .navigationBarBackButtonHidden()
        .padding(.top, 16)
        .padding(.horizontal)
    }
}

