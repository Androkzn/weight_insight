//
//  DoubleWheelPickerView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct DoubleWheelPickerView: View {
    @Binding var selectedWeight: Double
    @Binding var isPickerExpanded: Bool
    
    var body: some View {
        HStack {
            Picker(selection: Binding(
                get: { Int(selectedWeight) },
                set: { selectedWeight = Double($0) }
            ), label: Text("kg")) {
                ForEach(0...200, id: \.self) { kg in
                    Text("\(kg)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
            .onAppear() {
                if selectedWeight == 0 {
                    selectedWeight = 50
                }
            }
            
            Text(".")
            
            Picker(selection: Binding(
                get: { Int((selectedWeight - Double(Int(selectedWeight))) * 100) },
                set: { selectedWeight = Double(Int(selectedWeight)) + Double($0) / 100 }
            ), label: Text("g")) {
                ForEach(0...99, id: \.self) { grams in
                    Text(String(format: "%02d", grams))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
        .padding()
        .background(Color.white)
    }
}
