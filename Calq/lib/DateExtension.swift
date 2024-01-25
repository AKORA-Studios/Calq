//
//  DateExtension.swift
//  Calq
//
//  Created by Kiara on 25.01.24.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int64 {
           Int64((self.timeIntervalSince1970 * 1000.0).rounded())
       }
}
