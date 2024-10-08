//
//  CurrentTaskWidgetLiveActivity.swift
//  CurrentTaskWidget
//
//  Created by lea.Wang  on 7/10/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CurrentTaskWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CurrentTaskWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CurrentTaskWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CurrentTaskWidgetAttributes {
    fileprivate static var preview: CurrentTaskWidgetAttributes {
        CurrentTaskWidgetAttributes(name: "World")
    }
}

extension CurrentTaskWidgetAttributes.ContentState {
    fileprivate static var smiley: CurrentTaskWidgetAttributes.ContentState {
        CurrentTaskWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CurrentTaskWidgetAttributes.ContentState {
         CurrentTaskWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CurrentTaskWidgetAttributes.preview) {
   CurrentTaskWidgetLiveActivity()
} contentStates: {
    CurrentTaskWidgetAttributes.ContentState.smiley
    CurrentTaskWidgetAttributes.ContentState.starEyes
}
