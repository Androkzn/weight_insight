//
//  StatisticCell.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-31.
//

import SwiftUI

struct StatisticCell: View {
    let imageName: String
    let color: Color
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
            Text(value)
                .foregroundColor(["0", "0.0"].contains(value) ?  .red : .black)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
    }
}
