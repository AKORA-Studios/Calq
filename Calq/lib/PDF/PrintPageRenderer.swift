//
//  PrintPageRenderer.swift
//  Calq
//
//  Created by Kiara on 23.11.24.
//

import UIKit

class PrintPageRenderer: UIPrintPageRenderer {
    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
        let pageframe = CGRect(x: 0, y: 0, width: A4PageWidth, height: A4PageHeight)
        self.setValue(NSValue(cgRect: pageframe), forKey: "paperRect")
        self.setValue(NSValue(cgRect: CGRectInset(pageframe, 10, 10)), forKey: "printableRect")
    }
}
