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

    var body: some View {
        Form {
            Section(header: Text("Your Goals")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.blue)
            ) {
                HStack {
                    Text("\(Statistic.weight.title):")
                    Spacer()
                    CustomTextField(text: $viewModel.goals.weightGoal, placeholder: Statistic.weight.placeholder, keyboardType: .decimalPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .weight)
                    })
                    .frame(width: 100)
                }
                 
                HStack {
                    Text("\(Statistic.steps.title):")
                    Spacer()
                    CustomTextField(text: $viewModel.goals.stepsGoal, placeholder: Statistic.steps.placeholder, keyboardType: .numberPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .steps)
                    })
                    .frame(width: 100)
                } 
                HStack {
                    Text("\(Statistic.calories.title):")
                    Spacer()
                    CustomTextField(text: $viewModel.goals.caloriesGoal, placeholder: Statistic.calories.placeholder, keyboardType: .numberPad, onDone: { value in
                        viewModel.saveSettingValue(value, for: .calories)
                    })
                    .frame(width: 100)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(height: 40)
        
            Section(header: Text("Connected apps")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.blue)
            ) {
                HStack {
                    Text("MyFitnessPal:")
                    Spacer()
                    Button(action: {
                        self.viewModel.showWebView = true
                    }) {
                        Text("Connect")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.green)
                    }
                    .sheet(isPresented: $viewModel.showWebView) {
//                        WebView(requestURL: URL(string: "https://www.myfitnesspal.com/food/diary/atekhtelev")!) { code in
//                           self.authorizationCode = code
//                           self.showWebView = false
//                        }
                        WebView(requestURL: URL(string: "http://api.myfitnesspal.com/v2/oauth2/auth?client_id=atekhtelev&response_type=code&scope=diary+measurements+private-exercises+subscriptions&redirect_uri=http://weightinsight.com/settings")!) { code in
                            viewModel.authorizationCode = code
                            viewModel.showWebView = false
                        }
                    }
                    .cornerRadius(10)
                    .disabled(true)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(height: 40)
                HStack() {
                    Text("Fat Secret:")
                    Spacer()
                    Button(action: {
                        self.viewModel.showWebView = true
                    }) {
                        Text("Connect")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.green)
                    }
                    .sheet(isPresented: $viewModel.showWebView) {
//                        WebView(requestURL: URL(string: "https://www.myfitnesspal.com/food/diary/atekhtelev")!) { code in
//                           self.authorizationCode = code
//                           self.showWebView = false
//                        }
                        WebView(requestURL: URL(string: "http://api.myfitnesspal.com/v2/oauth2/auth?client_id=atekhtelev&response_type=code&scope=diary+measurements+private-exercises+subscriptions&redirect_uri=http://weightinsight.com/settings")!) { code in
                            viewModel.authorizationCode = code
                            viewModel.showWebView = false
                        }
                    }
                    .cornerRadius(10)
                    .disabled(true)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(height: 40)
            Section(header: Text("Settings")
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.blue)
            ) {
                HStack() {
                    Text("Units:")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 00))
                    Spacer()
                    Picker("", selection:  $viewModel.units) {
                        ForEach(Units.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .pickerStyle(.menu)
                    .tint(.black)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(height: 40)
        }
    }
}
#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsView.ViewModel())
            .environmentObject(MainView.ViewModel(dataService: RealmService()))
    }
}
#endif
