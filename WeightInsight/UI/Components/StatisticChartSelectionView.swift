//
//  StatisticChartSelectionView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-22.
//

import SwiftUI

struct StatisticChartSelectionView: View {
    @Binding var selectedChartStatistic: [Statistic]

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                ForEach(Statistic.allCases, id: \.self) { statistic in
                    Button(action: {
                        if selectedChartStatistic.contains(statistic) {
                            // Ensure that at least one item remains selected
                            if selectedChartStatistic.count > 1 {
                                selectedChartStatistic.removeAll { $0 == statistic }
                            }
                        } else {
                            selectedChartStatistic.append(statistic)
                        }
                    }) {
                        Text(statistic.rawValue.capitalized)
                            .frame(width: (geometry.size.width - 40) / 3, height: 25) // 40 accounts for total leading and trailing padding and spaces between buttons
                            .background(
                                selectedChartStatistic.contains(statistic) ? Color.blue.opacity(0.5) : Color.gray
                            )
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .frame(height: 20)
    }
}
