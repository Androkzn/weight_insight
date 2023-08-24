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
            TextFieldWithImage(title: "Weight", placeholder: "Enter weight", text: $entry.weight, systemImageName: "scalemass", keyboardType: .decimalPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.weight)
                }
            TextFieldWithImage(title: "Steps", placeholder: "Enter steps", text: $entry.steps, systemImageName: "figure.walk", keyboardType: .numberPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.steps)
                }
            TextFieldWithImage(title: "Calories", placeholder: "Enter calories", text: $entry.calories, systemImageName: "flame", keyboardType: .numberPad)
                .onTapGesture {
                    clearTextFieldIfNeeded($entry.calories)
                }
            HStack {
                Button("Save") {
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
    let title: String
    let placeholder: String
    @Binding var text: String
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
