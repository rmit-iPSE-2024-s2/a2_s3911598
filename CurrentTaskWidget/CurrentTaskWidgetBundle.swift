//
//  CurrentTaskWidgetBundle.swift
//  CurrentTaskWidget
//
//  Created by lea.Wang on 7/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct CurrentTaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        CurrentTaskWidget()
        CurrentTaskWidgetLiveActivity()
    }
}
