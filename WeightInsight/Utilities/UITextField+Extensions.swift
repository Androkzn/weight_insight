//
//  UITextField+Extensions.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-14.
//

import Foundation
import SwiftUI
import UIKit

extension UITextField {
    
    func addDoneButton(doneButtonAction: @escaping () -> Void) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTapped(button:)))
        ]
        toolBar.sizeToFit()
        self.inputAccessoryView = toolBar

        objc_setAssociatedObject(self, &key, doneButtonAction, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
        if let action = objc_getAssociatedObject(self, &key) as? (() -> Void) {
            action()
        }
    }
}

private var key: UInt8 = 0

