//
//  DoubleExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import Foundation

extension Double {
    func getTimeFormattedWithoutHour(divider: String = ":") -> String {
        let value = Int(self)
        return String(format: "%02d" + divider + "%02d", value/60,value%60)
    }
    
    func radians() -> Double {
        return self * .pi / 180
    }
}
