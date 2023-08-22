//
//  TodayStatisticBoxView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct  SingleStatisticBoxView: View {
    @EnvironmentObject var viewModel:   MainView.ViewModel
    @Binding var value: Double
    @Binding var isEditingTodayStatistic: Bool
    @Binding var selectedDate: Date
    @Binding var selectedStatisticType: Statistic
    
    @State private var isEditing: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var statisticType: Statistic
    var onButtonTapped: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(statisticType.title)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))

            TextField("", value: $value, formatter: NumberFormatter.decimalFormatter)
                .keyboardType(.decimalPad)
                .background(Color.clear)
                .cornerRadius(10)
                .focused($isTextFieldFocused)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                .onChange(of: isTextFieldFocused) { focused in
                    // Respond to focus changes
                    if focused {
                        isEditing = true
                        isEditingTodayStatistic = true
                        selectedStatisticType = statisticType
                    }
                }
                .disabled(isEditingTodayStatistic && !isTextFieldFocused && selectedStatisticType != statisticType )
            Button(action: {
                // Save new data to Realm when the Save button pressed
                if isEditing {
                    viewModel.saveStatisticData(statistic: statisticType, value: value, date: selectedDate)
                }

                isEditingTodayStatistic = isEditing
                selectedStatisticType = statisticType
                
                isEditing.toggle()
                if isEditing {
                    isTextFieldFocused = true
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
    
                onButtonTapped()
            }) {
                Image(systemName: isEditing ? "checkmark" : (value == 0 ? "plus" : "pencil"))
                    .foregroundColor(.white)
                    .padding(15)
                    .background(isEditing ? Color.green : Color.blue.opacity(0.6))
                    .clipShape(Circle())  // This makes the button round
            }
            .disabled(isEditingTodayStatistic && !isEditing) // This disables the button if any box is editing and the current box is not.
        }
        //.frame(width: 80, height: 120)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .background(Color.orange.opacity(0.3))
        .cornerRadius(10)
    }
}
