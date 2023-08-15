//
//  TodayStatisticBoxView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct  TodayStatisticBoxView: View {
    @EnvironmentObject var viewModel:   MainView.ViewModel
    @Binding var value: Double
    @Binding var isEditingTodayStatistic: Bool
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
 
    
    var statisticType: Statistic
    var onButtonTapped: () -> Void
    
    @ViewBuilder
    var textField: some View {
        TextField("", value: $value, formatter: NumberFormatter.decimalFormatter)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.clear)
            .cornerRadius(8)
            .focused($isTextFieldFocused)
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(statisticType.title)
                .font(.headline)
      
            // Make additional setup for text field if needed
            if [Statistic.weight, Statistic.weight].contains(statisticType) {
                textField.disabled(true)
            } else {
                textField
            }
            
            Button(action: {
                // Save new data to Realm when the Save button pressed
                if isEditing {
                    viewModel.saveStatisticData(statistic: statisticType, value: value)
                }
                
                isEditingTodayStatistic = isEditing
                
                
                if statisticType == Statistic.weight {
                    isEditing.toggle()
                } else {
                    isEditing.toggle()
                    if isEditing {
                        isTextFieldFocused = true
                    } else {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                
                onButtonTapped()
            }) {
                Text(isEditing ? "Save" : "Add")
                    .padding()
                    .foregroundColor(.white)
                    .background(isEditing ? Color.green : Color.gray)
            }
            .disabled(isEditingTodayStatistic && !isEditing) // This disables the button if any box is editing and the current box is not.
            .cornerRadius(10)
            
            Spacer()
        }
        .frame(width: 80, height: 120)
        .padding()
        .background(Color.orange)
        .cornerRadius(10)
    }
}
