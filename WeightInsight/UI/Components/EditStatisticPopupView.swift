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
    @Binding var showEditPopup: Bool
    
    let saveAction: (StatisticData) -> Void
    var isFormValid: Bool {
        return !entry.weight.isEmpty && !entry.steps.isEmpty  && !entry.calories.isEmpty
    }
    
    // Clear the text field if the value is 0 or 0.0
    func clearTextFieldIfNeeded(_ value: Binding<String>) {
        if value.wrappedValue == "0" || value.wrappedValue == "0.00" {
            value.wrappedValue = ""
        }
    }
    
    var body: some View {
        VStack {
            Text("Edit \(entry.date?.formattedString(format: "dd MMMM yyyy") ?? "")")
                .font(.headline)
                .bold()
            TextFieldWithImage(text: $entry.weight, title: Statistic.weight.title, placeholder:  Statistic.weight.placeholder, systemImageName:  Statistic.weight.image, keyboardType: .decimalPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.weight)
                }
            TextFieldWithImage(text: $entry.steps, title:  Statistic.steps.title, placeholder: Statistic.steps.placeholder, systemImageName: Statistic.steps.image, keyboardType: .numberPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.steps)
                }
            TextFieldWithImage(text: $entry.calories, title: Statistic.calories.title, placeholder: Statistic.calories.placeholder, systemImageName: Statistic.calories.image, keyboardType: .numberPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.calories)
                }
            HStack {
                Button("Save") {
                    entry.sanitizeData()
                    saveAction(entry)
                }
                .buttonStyle(MyButtonStyle(isEnabled: isFormValid, color: .green))
                .disabled(!isFormValid)
                
                Button("Cancel") {
                    showEditPopup = false
                }
                .buttonStyle(MyButtonStyle(isEnabled: true, color: .blue))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(width: 300, height: 200)
    }
}

struct TextFieldWithImage: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    let title: String
    let placeholder: String
    let systemImageName: String
    let keyboardType: UIKeyboardType
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 70)
            Image(systemName: systemImageName)
                .foregroundColor(getImageColor())
                .frame(width: 20)
            TextField(placeholder, text: $text)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .multilineTextAlignment(.center)
                .keyboardType(keyboardType)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { focused in
                    // Do not show "," if text field is editing
                    isEditing = focused
                    text = isEditing ? text.withoutThousandsSeparator : text.withThousandsSeparator
                }
        }
    }
    
    func getImageColor() -> Color {
        if systemImageName == "scalemass" {
            return .blue
        } else if systemImageName == "figure.walk" {
            return .green
        } else {
            return .orange
        }
    }
}

struct MyButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 100, height: 40)
            .foregroundColor(.white)
            .background(isEnabled ? color.opacity(0.7) : Color.gray)
            .cornerRadius(10)
            .disabled(!isEnabled)
    }
}
