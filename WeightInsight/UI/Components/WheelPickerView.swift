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
        .onChange(of: selectedItem) { _ in
            withAnimation {
                isPickerExpanded.toggle()
            }
        }
    }
}
