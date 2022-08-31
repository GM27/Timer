//
//  CellModel.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/9/22.
//

import Foundation

struct CellModel: Codable {
  static var isViewInUse = false 
    var cellNumber: Int 
    var playTapped = false
    var pauseTapped = true
    var resetTapped = false
    var currentHours: Int
    var currentMinutes: Int
    var currentSeconds: Int
    var name: String
    var isDisplayingDelete = false
    
    
}
