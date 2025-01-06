//
//  DoubleExtension.swift
//  Calq
//
//  Created by Kiara on 20.02.23.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var shorted: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
          return String(format: "%.0f", self)
        }
        return String(format: "%.0f", self)
    }
}
