//
//  TimeIntervalExtension.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/31/22.
//

import Foundation


extension TimeInterval {
    var hourMinuteSecondMS: String {
        String(format:"%d:%02d:%02d.%03d", hour, minute, second, millisecond)
    }
    var minuteSecondMS: String {
        String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var hour: Int {
       return  Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
      return  Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
       return Int(truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
       return Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
