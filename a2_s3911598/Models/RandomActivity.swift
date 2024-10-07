//
//  RandomActivity.swift
//  a2_s3911598
//
//  Created by zachary.zhao on 7/10/2024.
//

// ActivityModel.swift

import Foundation

final class ActivityModel: ObservableObject {
    @Published var result: ActivityResult? = nil
    
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


struct ActivityResult: Codable, Equatable {
    let activity: String
    let type: String
}


