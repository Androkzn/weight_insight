//
//  SettingsView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import Foundation
import UIKit
import SwiftUI
import Combine

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var myFitnessPal: String = ""
    @State private var showWebView: Bool = false
    @State private var authorizationCode: String? = nil
        

    var body: some View {
        Form {
            Section(header: Text("Your Goals").font(.system(size: 20))) {
                HStack {
                    Text("Weight:")
                        .padding(10)
                    CustomTextField(text: $viewModel.dataStore.goals.weightGoal, placeholder: "Enter weight", keyboardType: .decimalPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .weight)
                    })
                }
                HStack {
                    Text("Steps:")
                        .padding(10)
                    CustomTextField(text: $viewModel.dataStore.goals.stepsGoal, placeholder: "Enter steps", keyboardType: .numberPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .steps)
                    })
                }
                HStack {
                    Text("Calories:")
                        .padding(10)
                    CustomTextField(text: $viewModel.dataStore.goals.caloriesGoal, placeholder: "Enter calories", keyboardType: .numberPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .calories)
                    })
                }
                HStack {
                    Text("MyFitnessPal:")
                        .padding(10)
                    Button(action: {
                        self.showWebView = true
                    }) {
                        Text("Connect")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                    }
                    .sheet(isPresented: $showWebView) {
//                        WebView(requestURL: URL(string: "https://www.myfitnesspal.com/food/diary/atekhtelev")!) { code in
//                           self.authorizationCode = code
//                           self.showWebView = false
//                        }
                        WebView(requestURL: URL(string: "http://api.myfitnesspal.com/v2/oauth2/auth?client_id=atekhtelev&response_type=code&scope=diary+measurements+private-exercises+subscriptions&redirect_uri=http://weightinsight.com/settings")!) { code in
                           self.authorizationCode = code
                           self.showWebView = false
                        }
                    }
                    .cornerRadius(10)
                    .disabled(true)
                }
            }
        }
    }
}
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
#endif
