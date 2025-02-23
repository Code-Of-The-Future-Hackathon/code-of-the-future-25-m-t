//
//  CostItemRowView.swift
//  MT
//
//  Created by Mihail Kolev on 23/02/2025.
//

import SwiftUI

struct CostItemRowView: View {
    var currency: String
    var laborCost: Double
    var totalCost: Double
    var materialsCost: Double
    var shortIssueName: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(shortIssueName)
                .font(.body)
                .fontWeight(.medium)

            HStack {
                VStack {
                    Text("Labor cost")
                    Text("\(currency) \(laborCost, specifier: "%.2f")")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(width: 100, alignment: .center)
                }

                VStack {
                    Text("Material cost")
                    Text("\(currency) \(materialsCost, specifier: "%.2f")")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(width: 100, alignment: .center)
                }

                VStack {
                    Text("Total cost")
                    Text("\(currency) \(totalCost, specifier: "%.2f")")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(width: 100, alignment: .center)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
