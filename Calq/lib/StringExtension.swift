//
//  StringExtension.swift
//  Calq
//
//  Created by Kiara on 16.07.23.
//

import Foundation

extension String {
    var localized: String {
      return NSLocalizedString(self, comment: "")
    }
}
