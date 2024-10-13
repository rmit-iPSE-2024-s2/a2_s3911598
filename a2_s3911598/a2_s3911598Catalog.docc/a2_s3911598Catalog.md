# ``a2_s3911598``

、

## Summary
This project is an iOS app that focuses on task management, mood tracking, and social interactions among friends. It uses SwiftUI as the main framework with a Model-View structure. 
UIKit components in the project follow the MVVM (Model-View-ViewModel) architecture.

## Overview
The app allows users to create and manage tasks, track their moods, and share tasks with friends. It features interactive views like mood sliders, friend pickers, and task creation forms. The app also integrates with Auth0 for authentication and uses SwiftData for persistent storage of tasks and moods.

## Technology Stack

- **Frontend**: SwiftUI for declarative UI, UIKit integration for components like image pickers.
- **Backend**: SwiftData for local storage.
- **Authentication**: Auth0 for secure login.
- **Network**: URLSession for API calls.
- **Widget Extension**: SwiftUI for widget development.
- **Testing**: XCTest for unit tests.

## Custom Gesture

### TaskDetailView - Custom Gesture for Task Completion

In the ``TaskDetailView``, a custom gesture is implemented that allows users to mark a task as completed by drawing a checkmark on the screen. This feature enhances user experience by adding a fun, interactive way to complete tasks, rather than just tapping a button.

- **Long Press and Drag Gesture**: The gesture is initiated with a long press, and then users can drag their finger across the screen to draw the checkmark.
- **Checkmark Detection**: After the user completes the drawing, the app verifies if the drawn shape resembles a checkmark. If it does, the task is marked as completed.
- **User Feedback**: This adds a gamified element to task management, making it more engaging for users to complete tasks.

The gesture detection is handled through custom logic in the isCheckmarkShape function, which analyzes the points drawn on the screen.

---

## Widget Extension & UIKit Integration

### Widget Extension for Task Display

This app includes a **Widget Extension** that provides users with quick access to their current tasks directly from the home screen, using the `TaskWidgetView`. This extension is a crucial feature for task-oriented apps, as it allows users to view their tasks at a glance without needing to open the app.

- **Widget Logic**: The widget fetches task data from `UserDefaults` via the `TaskCodable` model. By storing task information in `UserDefaults`, the widget can remain updated with the latest task details even when the app is not actively running. To ensure data consistency, every time a task is added or deleted in the database, all current tasks are synchronized to `UserDefaults`. The widget is also refreshed to ensure it always displays the most up-to-date information. This synchronization ensures that the widget remains in sync with the app's task data, even when the app is not in the foreground.

- **Task Display**: The widget shows task titles and time, allowing users to stay on top of their schedule.

---

### UIKit Integration with MVVM Architecture

 UIKit components are used in the following areas:

- **ImagePicker**: UIKit’s `UIImagePickerController` is used for handling image selection tasks that are not natively available in SwiftUI. The integration is handled using the `UIViewControllerRepresentable` protocol, which allows SwiftUI to present UIKit views and controllers within a SwiftUI interface. Specifically, `ImagePickerCoordinator` is responsible for presenting the image picker, while ensuring seamless data flow between the SwiftUI view and UIKit.
  
- **MVVM Pattern in UIKit**: The image selection logic is abstracted into the `ImagePickerViewModel`, which plays a key role in the MVVM pattern. The `ImagePickerViewModel` is responsible for handling the business logic related to image selection, including setting the selected image, clearing the image, and providing an interface for the SwiftUI view to access these operations. By doing so, the view model ensures a clear separation of concerns, allowing the SwiftUI view (`CreateTaskView`) to focus on the UI layer while delegating logic-heavy tasks to the view model.
---

## Networking with URLSession

The app integrates networking capabilities to fetch data from external APIs using `URLSession`. Two models, `ActivityModel` and `QuoteModel`, are responsible for managing the data fetching logic. This approach allows the app to pull dynamic content from remote sources, enhancing user experience with live data.

### ActivityModel - Fetching Random Activities

The `ActivityModel` is responsible for fetching random activity suggestions from the **Bored API**. This allows users to receive random tasks or activities that they can engage in.

## Unit Testing

The project employs a **Unit Testing** strategy to ensure the reliability of core functionality. This approach emphasizes testing business logic and functionality rather than user interface (UI) elements. The primary focus is on testing critical features related to **Task** and **Mood** management.

### Unit Testing Approach

1. **Unit Testing**: 
   - All tests are strictly **unit tests** aimed at validating the underlying logic of core functionalities.
   - The goal is to verify the correctness of important functions, such as task creation, deletion, filtering, and management of state within the app.

2. **Mood Management Testing**:
   - **Mood Storage**: Unit tests validate that mood records are stored correctly in the database. These tests guarantee that mood entries persist over time and can be retrieved later as needed.
   - **Fetching Logic**: Tests also check that mood data is accurately retrieved based on specific conditions, such as filtering moods by date or fetching moods for a specific day. This ensures users can effectively track and view their mood history.

3. **Daily Task Testing**:
   - **Task Filtering**: Unit tests ensure that tasks are correctly categorized as "My Tasks" or "Shared Tasks." This verifies that tasks with collaborators are properly labeled and separated from personal tasks, ensuring accurate task representation for the user.
   - **Task Storage and Deletion**: The ability to store and delete tasks in the model context is rigorously tested. These tests confirm that tasks are created without missing information and can be removed from the database when required.
   - **Core Functionality**: Additional tests focus on verifying key functionalities, such as the completion of tasks through gestures, ensuring that these actions update the task’s state as expected.


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
- ``ProfileView``

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
- ``ImagePickerCoordinator``






