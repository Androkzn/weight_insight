//
//  TodayStatisticRowView.swift
//  WeightInsightWidgetExtension
//
//  Created by Andrei Tekhtelev on 2023-08-21.
//

import SwiftUI

struct TodayStatisticRowView: View {
    var imageName: String
    var color: Color
    var value: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(6)
                .frame(width: 25, height: 25)
                .foregroundColor(color)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 2)
                )
            Text(value)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
