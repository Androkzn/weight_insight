//
//  ContentView.swift
//  weight_insight
//
//  Created by Andrei Tekhtelev on 2023-08-13.
//

import SwiftUI


@main
struct WeightInsightApp: App {
    @StateObject private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}


struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}
 

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedOption: String = "This Week"
    @State private var selectedWeight: Double = 0
    @State private var selectedWeightGrams: Double = 0
    @State private var selectedSteps: Double = 0
    @State private var selectedCalories: Double = 0
    @State private var isPickerExpanded: Bool = false
    @State private var predefinedFilters: [String] = ["This Week", "Previous Week", "This Month", "Previous Month", "All"]
    @State private var isWeightPickerExpanded: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                BoxView(title: "Weight", value: "\(viewModel.statisticData.last?.weight ?? 0.0)", goalValue: "50")
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
                
                BoxView(title: "Steps", value: "\(viewModel.statisticData.last?.steps ?? 0)",goalValue: "10000")
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
                
                BoxView(title: "Calories", value: "\(viewModel.statisticData.last?.calories ?? 0.0)", goalValue: "1200")
                    .frame(width: 110, height: 100) // Set a fixed width and height for each box
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                withAnimation {
                    isPickerExpanded.toggle()
                }
            }) {
                Text(selectedOption)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            if isPickerExpanded {
                WheelPicker(data: $predefinedFilters, selectedItem: $selectedOption) {
                    withAnimation {
                        isPickerExpanded.toggle()
                    }
                }
                .frame(height: 150)
                .padding(.horizontal)
                .transition(.slide)
            }
            
            Text("Your numbers today")
                .font(.headline)
                .padding(.top, 20)
            

            HStack(spacing: 10) {
                BoxViewEditable(title: "Weight", value: $selectedWeight, buttonTitle: "Add weight") {
                    withAnimation {
                        isWeightPickerExpanded.toggle()
                    }             }
                BoxViewEditable(title: "Steps", value: $selectedSteps, buttonTitle: "Add steps") {
                    
                }
                BoxViewEditable(title: "Calories", value: $selectedCalories, buttonTitle: "Import calories") {
                    
                }
            }
            .padding()
            
            if isWeightPickerExpanded {
                DoubleWheelPickerView(selectedWeight: $selectedWeight, isPickerVisible: $isWeightPickerExpanded)
                    .transition(.move(edge: .bottom))
            }
            
        }
    }
}

struct BoxViewEditable: View {
    var title: String
    @Binding var value: Double
    var buttonTitle: String
    var onButtonTapped: () -> Void // Add a closure for the button action
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    @ViewBuilder
    var textField: some View {
        TextField("", value: $value, formatter: NumberFormatter.decimalFormatter)
            .keyboardType(.numberPad)
            .padding()
            .background(Color.clear)
            .cornerRadius(8)
            .focused($isTextFieldFocused)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
      
            textField
            
            Button(action: {
                if title == "Weight" {
                    isEditing.toggle()
                    
                    let currentDate = Date().formattedString(format: "yyyy-MM-dd")
                    let realm = RealmManager.shared.realm
    
                    if let existingData = realm.objects(StatisticData.self).filter("id = %@", currentDate).first {
                        try? realm.write {
                            existingData.weight = value
                        }
                    } else {
                        let newData = StatisticData()
                        newData.id = currentDate
                        newData.weight = value
                        try? realm.write {
                            realm.add(newData)
                        }
                    }
                    
                } else if title == "Steps" {
                    isEditing.toggle()
                    if isEditing {
                        isTextFieldFocused = true // Focus the TextField immediately
                    } else {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                } else if title == "Calories" {
                    // Make a network call to import calories
                }
                
                onButtonTapped()
                
            }) {
                Text(isEditing ? "Save" : buttonTitle)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(isEditing ? Color.green : Color.clear)
            }
            .cornerRadius(10)
            
            Spacer()
        }
        .frame(width: 80, height: 150)
        .padding()
        .background(Color.orange)
        .cornerRadius(10)
    }
}



struct DoubleWheelPickerView: View {
    @Binding var selectedWeight: Double
    @Binding var isPickerVisible: Bool
    
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
                    Text(String(format: "%02d", grams)) // Format to always show two digits
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100)
        }
        .padding()
        .background(Color.white)
    }
}



struct WheelPicker: View {
    @Binding var data: [String]
    @Binding var selectedItem: String
    var onItemSelected: (() -> Void)?
    
    var body: some View {
        Picker("", selection: $selectedItem) {
            ForEach(data, id: \.self) { item in
                Text(item)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: selectedItem) { _ in
            onItemSelected?()
        }
    }
}

struct BoxView: View {
    var title: String
    var value: String
    var goalValue: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.subheadline)
            Spacer()
            Text("Goal: \(goalValue)")
                .font(.subheadline)
        }
        .padding(10)
    }
}



struct StatisticsView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        List(viewModel.statisticData) { entry in
            Text("Date: \(entry.date.formattedString(format: "yyyy-MM-dd"))")
            Text("Weight: \(entry.weight)")
            Text("Steps: \(entry.steps)")
            Text("Calories: \(entry.calories)")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var weightGoal: Double = 0.0
    @State private var stepsGoal: Int = 0
    @State private var caloriesGoal: Double = 0.0
    
    var body: some View {
        Form {
            Section(header: Text("Goals")) {
                TextField("Weight Goal", value: $weightGoal, format: .number)
                Stepper("Steps Goal: \(stepsGoal)", value: $stepsGoal)
                TextField("Calories Goal", value: $caloriesGoal, format: .number)
            }
            
            Button("Save Goals") {
                // Save goals to Realm
            }
        }
    }
}
