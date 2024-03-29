//
//  DeleteStatisticPopupView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-20.
//

import Foundation
import SwiftUI

struct ClearStatisticPopupView: View {
    let entryId: String
    
    var onClear: (String) -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("All data will be reset for \(entryId)")
                .font(.headline)
                .padding()
                .multilineTextAlignment(.center)

            HStack(spacing: 20) {
                Button("Cancel") {
                    onCancel()
                }
                .frame(width: 70, height: 20)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
  

                Button("Clear") {
                    onClear(entryId)
                }
                .frame(width: 70, height: 20)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
            }.padding(10)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(width: 300, height: 200)
    }
}

