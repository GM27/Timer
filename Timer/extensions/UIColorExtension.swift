//
//  UIColorExtension.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/25/22.
//

import Foundation
import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
   
    static var bodyColor: UIColor {return UIColor(rgb: 0x90b4de)}
    static var viewColor: UIColor{return UIColor(rgb: 0x4f7bb3)}
    static var bar2ControllerColor : UIColor{return UIColor(rgb:  0x446691 )}
    static var kindaDarkGray: UIColor{return UIColor(rgb: 0x596169)}
    static var redWeNeed: UIColor{return UIColor(rgb: 0xBD5571)}
    static var greenWeNeed: UIColor{return UIColor(rgb: 0x44A391)}
    static var resetColor: UIColor{return UIColor(rgb: 0x7d93b0)}
    static var timelabelColor: UIColor{return UIColor(rgb: 0x4f7bb3)}
    static var cellColor: UIColor{return UIColor(rgb: 0x90b4de)}
    
}



extension UIColor {
    convenience init(rgb: UInt) {
       self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}


