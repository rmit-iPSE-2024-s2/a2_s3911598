//
//  CurrentTaskWidgetBundle.swift
//  CurrentTaskWidget
//
//  Created by lea.Wang on 7/10/2024.
//

import WidgetKit
import SwiftUI

/// The `CurrentTaskWidgetBundle` struct defines the widget bundle for the app.
/// It serves as the entry point for the widget extension, allowing the system to recognize the widget.
@main
struct CurrentTaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        CurrentTaskWidget()
    }
}

