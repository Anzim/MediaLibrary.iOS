//
//  UIView+border.swift
//  LoginApp
//
//  Created by Andriy Zymenko on 30.08.16.
//  Copyright © 2016 Andriy Zymenko. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {

    @IBInspectable var cornerRadius: CGFloat? {
        get {
            return layer.cornerRadius
        }
        set {
            if let newCornerRadius = newValue {
                layer.cornerRadius = newCornerRadius
                layer.masksToBounds = newCornerRadius > 0
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            } else {
                return UIColor.black
            }
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

}

