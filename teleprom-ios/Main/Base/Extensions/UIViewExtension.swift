//
//  UIViewExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
