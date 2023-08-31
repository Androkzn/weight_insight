//
//  MissingDataView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-31.
//

import SwiftUI

struct MissingDataView: View {
    let data: StatisticDataObject
 
    var body: some View {
        Group {
            if data.weight == 0 || data.steps == 0 || data.calories == 0 {
                VStack(alignment: .center) {
                    Image("missing_data")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    Text("Missing data")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }
                .padding(5)
                .frame(width: 60)
                .background(Color.orange.opacity(0.5))
                .cornerRadius(8)
            } else {
                EmptyView()
            }
        }
    }
}
