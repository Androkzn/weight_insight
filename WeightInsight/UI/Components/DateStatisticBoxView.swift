//
//  TodayStatisticBoxView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct  DateStatisticBoxView: View {
    @EnvironmentObject var viewModel: MainView.ViewModel
    
    @Binding var value: Double
    @State var valueString: String
    @Binding var isEditingTodayStatistic: Bool
    @Binding var selectedDate: Date
    @Binding var selectedStatisticType: Statistic?
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    var statisticType: Statistic
    
    var body: some View {
        let isDisabled = selectedStatisticType != nil && selectedStatisticType != statisticType
        VStack(spacing: 0) {
            Text(statisticType.title)
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            TextField(statisticType.placeholder, text: $valueString)
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
                .onReceive(Just(valueString)) { value in
                    // Do not show "," if text field is editing
                    let newValue = isEditing ? value.withoutThousandsSeparator : value.withThousandsSeparator
                    // Replace 0 with empty string in the displayed value
                    valueString = newValue == "0" ? "" : newValue
                    
                }
                .disabled(isDisabled)
            Button(action: {
                // Save new data to Realm when the Save button pressed
                if isEditing {
                    let value = Double(valueString) ?? 0
                    viewModel.saveStatisticData(statistic: statisticType, value: value, date: selectedDate)
                    self.value = value
                }
                
                isEditing.toggle()
                
                isEditingTodayStatistic = isEditing
                
                if isEditing {
                    isTextFieldFocused = true
                    selectedStatisticType = statisticType
                } else {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    selectedStatisticType = nil
                }
            }) {
                Image(systemName: isEditing ? "checkmark" : (value == 0 ? "plus" : "pencil"))
                    .foregroundColor(.white)
                    .padding(15)
                    .background(isEditing ? Color.green : Color.blue.opacity(0.6))
                    .clipShape(Circle())  // This makes the button round
            }
            .disabled(isDisabled)
            
            // This disables the button if any box is editing and the current box is not.
        }
        //.frame(width: 80, height: 120)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .background(Color.orange.opacity(0.3))
        .cornerRadius(10)
    }
}
