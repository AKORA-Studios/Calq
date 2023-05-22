//
//  LineChartWidgetViewmodel.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 22.05.23.
//

import Foundation

class LineChartWidgetViewmodel: ObservableObject {
    @Published var lineChartEntries: [[LineChartEntry]] = []
    
    func updateViews(){
        self.objectWillChange.send()
        lineChartEntries = lineChartData()
    }
}
