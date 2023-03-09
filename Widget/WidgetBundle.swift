//
//  WidgetBundle.swift
//  Widget
//
//  Created by Kiara on 09.03.23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetBundle: SwiftUI.WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        MediumBarWidget()
        SmallCircleWidget()
    }
}
