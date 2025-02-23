//
//  ATMProcessView.swift
//  MT
//
//  Created by Ivan Gamov on 23.02.25.
//

import SwiftUI

//struct ATMProcessView: View {
//    let steps = [
//        "Insert ATM Card",
//        "Select transaction and enter pin",
//        "Select type of Account",
//        "Collect Cash"
//    ]
//    
//    @State private var completedSteps = 2 // Set the number of completed steps (e.g., 2 steps completed)
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            ForEach(0..<steps.count, id: \.self) { index in
//                HStack {
//                    // Circle for step
//                    Circle()
//                        .strokeBorder(index < completedSteps ? Color.teal : Color.teal, lineWidth: 2)
//                        .background(Circle().fill(index < completedSteps ? Color.teal : Color.clear))
//                        .frame(width: 20, height: 20)
//
//                    // Step Text
//                    Text(steps[index])
//                        .font(.body)
//                        .foregroundColor(index < completedSteps ? .teal : .gray)
//                    
//                    Spacer() // Pushes everything to the left
//
//                }
//                // Line between steps
//                if index < steps.count - 1 {
//                    Rectangle()
//                        .frame(width: 2, height: 20)
//                        .foregroundColor(index < completedSteps - 1 ? .teal : .gray)
//                        .padding(.leading, 9)
//                        .padding(.vertical, -2)
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//
//#Preview {
//        ATMProcessView()
//}



//struct ATMProcessView: View {
//    let steps = [
//        "First - 100 points",
//        "Second - 200 points",
//        "Third - 300 points",
//        "Fourth - 400 points"
//    ]
//    
//    let totalPoints = 400 // Total points for the last step
//    let currentPoints = 240 // Current points
//    let progressPercentage: CGFloat
//    
//    @State private var completedSteps = 2 // Set the number of completed steps (e.g., 2 steps completed)
//
//    init() {
//        // Calculate the percentage of progress between the current step and the next
//        let nextStepPoints = 300 // Points at the second step
//        progressPercentage = CGFloat(currentPoints) / CGFloat(nextStepPoints)
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            ForEach(0..<steps.count, id: \.self) { index in
//                HStack {
//                    // Circle for step
//                    Circle()
//                        .strokeBorder(index < completedSteps ? Color.teal : Color.teal, lineWidth: 2)
//                        .background(Circle().fill(index < completedSteps ? Color.teal : Color.clear))
//                        .frame(width: 20, height: 20)
//
//                    // Step Text
//                    Text(steps[index])
//                        .font(.body)
//                        .foregroundColor(index < completedSteps ? .teal : .gray)
//                    
//                    Spacer() // Pushes everything to the left
//                }
//                
//                // Line between steps
//                if index < steps.count - 1 {
//                    ZStack {
//                        // Full line (Vertical)
//                        Rectangle()
//                            .frame(width: 2, height: 50) // Adjust height as needed
//                            .foregroundColor(index < completedSteps - 1 ? .teal : .gray)
//                            .padding(.leading, 9)
//                            .padding(.vertical, -2)
//                        
//                        // Progress bar (Vertical)
//                        if index == 0 { // This will be drawn only between the first and second steps
//                            Rectangle()
//                                .frame(width: 2, height: 50 * progressPercentage) // Adjust height based on progress
//                                .foregroundColor(.teal)
//                                .padding(.leading, 9)
//                                .padding(.vertical, -2)
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//

import SwiftUI

import SwiftUI

struct ATMProcessView: View {
    let totalSteps = 7 // You can change this to any number
    let pointsPerStep = 100 // Each step has a specific point value (e.g., 100 points per step)
    
    let totalPoints = 700 // Total points for all steps (7 * 100)
    let currentPoints = 230 // Current points
    
    // Dynamically calculate the completed steps
    var completedSteps: Int {
        return currentPoints / pointsPerStep
    }
    
    // Calculate the progress in the current incomplete step
    var progressPercentage: CGFloat {
        let currentStepPoints = CGFloat(currentPoints % pointsPerStep)
        return currentStepPoints / CGFloat(pointsPerStep)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<totalSteps, id: \.self) { index in
                HStack {
                    // Circle for step
                    Circle()
                        .strokeBorder(index < completedSteps ? Color.teal : Color.gray, lineWidth: 2)
                        .background(Circle().fill(index < completedSteps ? Color.teal : Color.clear))
                        .frame(width: 20, height: 20)

                    // Step Text
                    Text("Step \(index + 1) - \(pointsPerStep * (index + 1)) points")
                        .font(.body)
                        .foregroundColor(index < completedSteps ? .teal : .gray)
                    
                    Spacer() // Pushes everything to the left
                }
                
                // Line between steps
                if index < totalSteps - 1 {
                    ZStack {
                        // Full line (Vertical)
                        Rectangle()
                            .frame(width: 2, height: 50) // Adjust height as needed
                            .foregroundColor(index < completedSteps - 1 ? .teal : .gray)
                            .padding(.leading, 9)
                            .padding(.vertical, -2)
                        
                        // Progress bar (Vertical) for the last step
                        if index == completedSteps - 1 {
                            Rectangle()
                                .frame(width: 2, height: 50 * progressPercentage, alignment: .top) // Adjust height based on progress
                                .foregroundColor(.teal)
                                .padding(.leading, 9)
                                .padding(.vertical, -2)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
        ATMProcessView()
}


//I  want
//
////
////  ATMProcessView.swift
////  MT
////
////  Created by Ivan Gamov on 23.02.25.
////
//
//import SwiftUI
//
//struct ATMProcessView: View {
//    let steps = [
//        "Insert ATM Card",
//        "Select transaction and enter pin",
//        "Select type of Account",
//        "Collect Cash"
//    ]
//    
//    @State private var completedSteps = 2 // Set the number of completed steps (e.g., 2 steps completed)
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            ForEach(0..<steps.count, id: \.self) { index in
//                HStack {
//                    // Circle for step
//                    Circle()
//                        .strokeBorder(index < completedSteps ? Color.teal : Color.teal, lineWidth: 2)
//                        .background(Circle().fill(index < completedSteps ? Color.teal : Color.clear))
//                        .frame(width: 20, height: 20)
//
//                    // Step Text
//                    Text(steps[index])
//                        .font(.body)
//                        .foregroundColor(index < completedSteps ? .teal : .gray)
//                    
//                    Spacer() // Pushes everything to the left
//
//                }
//                // Line between steps
//                if index < steps.count - 1 {
//                    Rectangle()
//                        .frame(width: 2, height: 20)
//                        .foregroundColor(index < completedSteps - 1 ? .teal : .gray)
//                        .padding(.leading, 9)
//                        .padding(.vertical, -2)
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}
//
//#Preview {
//        ATMProcessView()
//}
//
//to not have steps to have for example checkpoint
//
//first  - 100 points
//second - 200 points
//third - 300 points
//fourth - 400 points
//and etc
//
//for example
//
//and after that if i have for example 130 points to fill 0.3 percentage of the second line
//
//how to achieve this
