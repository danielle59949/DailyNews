//
//  UIViewExtension.swift
//  Helper
//
//  Created by Daniel Le on 18/11/2022.
//

import Foundation
import UIKit


public extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        } set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
