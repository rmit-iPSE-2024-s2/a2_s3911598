//
//  RandomActivity.swift
//  a2_s3911598
//
//  Created by lea.Wang on 7/10/2024.
//

// ActivityModel.swift

import Foundation

/// The `ActivityModel` class is responsible for fetching activity data from an API and publishing the result.
///
/// This class uses `URLSession` to perform a network request to the "Bored API" and decodes the JSON response into an `ActivityResult` object. The result is published to any subscribers using SwiftUI's `@Published` property wrapper.
final class ActivityModel: ObservableObject {
    
    /// The fetched activity result, if available. Initially set to `nil`.
    @Published var result: ActivityResult? = nil
    
    /// Fetches an activity from the "Bored API".
    ///
    /// This function sends a network request to the API and decodes the response into an `ActivityResult`. The result is published to the `result` property.
    func fetchActivity() {
        let urlString = "https://bored.api.lewagon.com/api/activity/"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Unable to get data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ActivityResult.self, from: data)
                DispatchQueue.main.async {
                    self.result = decodedData
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        task.resume()
    }
}

/// The `ActivityResult` struct represents the result of an activity fetched from the "Bored API".
///
/// This struct conforms to `Codable` and `Equatable`, making it suitable for decoding JSON and for comparison in SwiftUI.
struct ActivityResult: Codable, Equatable {
    
    /// The description of the activity.
    let activity: String
    
    /// The type or category of the activity.
    let type: String
}



