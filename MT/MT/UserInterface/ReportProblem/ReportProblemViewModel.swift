//
//  ReportProblemViewModel.swift
//  MT
//
//  Created by Ivan Gamov on 21.02.25.
//

import SwiftUI

class ReportProblemViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var image: UIImage? = nil
    @Published var isShowingCamera = false

    var isSubmitDisabled: Bool {
        return title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func submitReport() {
        print("Title: \(title)")
        print("Description: \(description)")
        print("Image: \(image != nil ? "Attached" : "None")")
    }
}
