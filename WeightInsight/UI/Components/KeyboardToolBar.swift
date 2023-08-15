//
//  KeyboardToolBar.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import Foundation
import SwiftUI

struct KeyboardToolBar: UIViewRepresentable {
    var doneButtonAction: () -> Void

    func makeUIView(context: UIViewRepresentableContext<KeyboardToolBar>) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.doneButtonTapped))

        toolbar.items = [spacer, doneButton]

        return toolbar
    }

    func updateUIView(_ uiView: UIToolbar, context: UIViewRepresentableContext<KeyboardToolBar>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var toolBar: KeyboardToolBar

        init(_ toolBar: KeyboardToolBar) {
            self.toolBar = toolBar
        }

        @objc func doneButtonTapped() {
            toolBar.doneButtonAction()
        }
    }
}
