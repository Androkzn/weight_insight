//
//  WheelPickerView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import SwiftUI
import Combine

struct WheelPickerView: View {
    private let predefinedFilters: [StatisticFilter] = StatisticFilter.allCases
    @Binding var selectedItem: StatisticFilter
    @Binding var isPickerExpanded: Bool

    var body: some View {
        Picker("", selection: $selectedItem) {
            ForEach(predefinedFilters, id: \.self) { item in
                Text(item.title)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 30)
                .opacity(0.1)
                .background(Color.blue.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        )
        .onChange(of: selectedItem) { _ in
            withAnimation {
                isPickerExpanded.toggle()
            }
        }
    }
}
