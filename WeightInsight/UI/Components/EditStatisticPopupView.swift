//
//  EditStatisticPopupView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import Foundation
import SwiftUI

struct EditStatisticPopupView: View {
    @Binding var entry: StatisticData

    let closeAction: (StatisticData) -> Void
    var isFormValid: Bool {
        return !entry.weight.isEmpty && !entry.steps.isEmpty  && !entry.calories.isEmpty
    }
    
    var body: some View {
        VStack {
            // Date
            Text("\(entry.date?.formattedString(format: "dd MMMM yyyy") ?? "")")
                .font(.headline)
                .bold()
            HStack {
                Text("Weight")
                    .frame(width: 70)
                Image(systemName: "scalemass")
                    .foregroundColor(.blue)
                    .frame(width: 20)
                TextField("Enter weight", text: $entry.weight)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numbersAndPunctuation)
            }
            HStack {
                Text("Steps")
                    .frame(width: 70)
                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
                    .frame(width: 20)
                TextField("Enter steps", text: $entry.steps)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                
            }
            HStack {
                Text("Calories")
                    .frame(width: 70)
                Image(systemName: "flame")
                    .foregroundColor(.orange)
                    .frame(width: 20)
                TextField("Enter calories", text: $entry.calories)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
            }
            Button("Save") {
                closeAction(entry)
            }
            .padding()
            .foregroundColor(.white)
            .background(isFormValid ? Color.green : Color.gray)
            .cornerRadius(10)
            .disabled(!isFormValid)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(width: 300, height: 200)
    }
}
