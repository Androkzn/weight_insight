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
    var units: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(6)
                .frame(width: 26, height: 26)
                .foregroundColor(color)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 1.5)
                )
            Text(value)
                .bold()
                .font(.system(size: 16))
            Text(units)
                .font(.system(size: 16))
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
