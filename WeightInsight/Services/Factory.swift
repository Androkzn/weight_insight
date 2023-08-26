//
//  Factory.swift
//  WeightInsight
//
//  Created by Andrei Tekhtelev on 2023-08-25.
//

import Foundation
import Combine

protocol Factory {
    var dataService: DataServiceProtocol { get }
}
