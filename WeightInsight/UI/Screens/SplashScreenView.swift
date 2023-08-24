//
//  SplashScreenView.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-15.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size: CGFloat = 0.0
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color(hex: "92C6FE")
                .edgesIgnoringSafeArea(.all)
            
            if isActive {
                ContentView()
            } else {
                VStack {
                    VStack(spacing: 30) {
                        Image("logo_white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        Image("name_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear() {
                        withAnimation (.easeInOut(duration: 2.0)) { // 2.0 seconds duration as an example
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
#endif
