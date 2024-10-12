# ``a2_s3911598``

、

## Summary
This project is an iOS app that focuses on task management, mood tracking, and social interactions among friends. It uses SwiftUI as the main framework with a Model-View structure. 
UIKit components in the project follow the MVVM (Model-View-ViewModel) architecture.

## Overview
The app allows users to create and manage tasks, track their moods, and share tasks with friends. It features interactive views like mood sliders, friend pickers, and task creation forms. The app also integrates with Auth0 for authentication and uses Core Data (via SwiftData) for persistent storage of tasks and moods.

## Topics

### Modal Views
The app employs several modal views to handle user interactions:

- **Task Management**
    - `CreateTaskView`: Allows users to create new tasks, including setting task details, uploading images, and sharing tasks with friends.
    - `TaskDetailView`: Displays detailed information about a selected task, with an interactive checkmark drawing feature to mark the task as completed.
  
- **Mood Tracking**
    - `MoodTrackingView`: Provides users with a slider to record their current mood, dynamically adjusting the background color and mood label.
    - `MoodDetailView`: Displays details of the user's mood, including a description and additional notes, and allows the user to save the mood for the day.
  
- **Friend Management**
    - `FriendsPickerView`: Allows users to select friends to collaborate on tasks or share moods. If no friends are available, users can add friends.
    - `AddFriendView`: A modal view for adding new friends to the user's contact list.




## Topics

### Group: Core Features
- **Task Creation**: Create, manage, and share tasks with friends.
- **Mood Tracking**: Record and monitor moods over time.
- **Friend Management**: Add, select, and share tasks or moods with friends.

### Group: MVVM (UIKit)
- **ActivityModel**
- **QuoteModel**
- **TaskCodable**


### SwiftUI Structure

### Models

- ``Profile``
- ``Friend``
- ``Mood``
- ``Task``
- ``TaskCodable``
- ``dateFormatter``



### Views

Friends
- ``FriendView``
- ``AddFriendView``

Settings
- ``SettingsView``
- ``GeneralView``

DailyTask
- ``CreateTaskView``
- ``DailyTaskView``
- ``TaskDetailView``
- ``TaskCard``
- ``FriendsPickerView``

Mood
- ``MoodDetailView``
- ``MoodTrackingView``
- ``CalendarView``
- ``MoodView``



### ViewModel
- ``ImagePickerViewModel``


## Custom Gesture

### TaskDetailView - Custom Gesture for Task Completion

In the ``TaskDetailView``, a custom gesture is implemented that allows users to mark a task as completed by drawing a checkmark on the screen. This feature enhances user experience by adding a fun, interactive way to complete tasks, rather than just tapping a button.

- **Long Press and Drag Gesture**: The gesture is initiated with a long press, and then users can drag their finger across the screen to draw the checkmark.
- **Checkmark Detection**: After the user completes the drawing, the app verifies if the drawn shape resembles a checkmark. If it does, the task is marked as completed.
- **User Feedback**: This adds a gamified element to task management, making it more engaging for users to complete tasks.

By allowing users to interact with tasks in this unique way, the gesture not only makes task completion more enjoyable but also provides instant visual feedback when the task is successfully marked as completed. The gesture detection is handled through custom logic in the `isCheckmarkShape` function, which analyzes the points drawn on the screen.

---

## Widget Extension & UIKit Integration

### Widget Extension for Task Display

This app includes a **Widget Extension** that provides users with quick access to their current tasks directly from the home screen, using the `TaskWidgetView`. This extension is a crucial feature for task-oriented apps, as it allows users to view their tasks at a glance without needing to open the app.

- **Widget Logic**: The widget fetches task data from `UserDefaults` via the `TaskCodable` model. By storing task information in `UserDefaults`, the widget can remain updated with the latest task details even when the app is not actively running.

- **Task Display**: The widget shows task titles and time, allowing users to stay on top of their schedule.

- **SwiftUI and UIKit**: While the widget is built with SwiftUI, it integrates seamlessly with UIKit for data persistence through `UserDefaults`. The `TaskCodable` model conforms to `Codable` for encoding and decoding task information to and from JSON, which makes the data easy to store and retrieve across the app and widget.

---

### UIKit Integration with MVVM Architecture

 UIKit components are used in the following areas:

- **ImagePicker**: In some areas of the app, UIKit’s `UIImagePickerController` is used for handling image selection, encapsulated in the `ImagePickerViewModel`. This demonstrates how UIKit can be effectively integrated into SwiftUI applications to provide access to system-level services like photo libraries.
  
- **MVVM Pattern in UIKit**: The `ImagePickerViewModel` adheres to the MVVM pattern by abstracting the logic for image picking, ensuring a clear separation between the view (SwiftUI), the model (image data), and the view model (handling image selection logic).

---

## Networking with URLSession

The app integrates networking capabilities to fetch data from external APIs using `URLSession`. Two models, `ActivityModel` and `QuoteModel`, are responsible for managing the data fetching logic. This approach allows the app to pull dynamic content from remote sources, enhancing user experience with live data.

### ActivityModel - Fetching Random Activities

The `ActivityModel` is responsible for fetching random activity suggestions from the **Bored API**. This allows users to receive random tasks or activities that they can engage in.







