//
//  TextField.swift
//  Timer
//
//  Created by Jeremy Merezhko on 8/20/22.
//

import Foundation
import UIKit


class TextField: UITextField {

  
        
        let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

        override  func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override  func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
    
  
    
}
