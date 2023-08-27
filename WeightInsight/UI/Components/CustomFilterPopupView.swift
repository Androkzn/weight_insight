//
//  CustomFilterPopupView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-26.
//

import Foundation
import UIKit
import SwiftUI

struct CustomFilterPopupView: View {
    @Binding var selectedStartDate: Date
    @Binding var selectedEndDate: Date
    @Binding var showCustomFilterPopup: Bool
    
    let onSelect: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                Text("Select date range")
                    .font(.headline)
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color.orange.opacity(0.5))
            
            VStack(alignment: .center) {
                HStack(alignment: .center){
                    Spacer(minLength: 10)
                    VStack {
                        Text("From:")
                        Spacer(minLength: 5)
                        DatePicker("", selection: $selectedStartDate,  in: ...Date(), displayedComponents: .date)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                    Spacer(minLength: 5)
                    VStack {
                        Text("To:")
                        Spacer(minLength: 5)
                        DatePicker("", selection: $selectedEndDate,  in: ...Date(), displayedComponents: .date)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                    Spacer(minLength: 10)
                }
                HStack {
                    Button("Select") {
                        showCustomFilterPopup = false
                        onSelect()
                    }
                    .frame(width: 70, height: 20)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(10)
                    Button("Cancel") {
                        showCustomFilterPopup = false
                        onCancel()
                    }
                    .frame(width: 70, height: 20)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.blue.opacity(0.5))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top) // Add top padding to separate from the blue header
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(width: 300, height: 200)
    }


}
