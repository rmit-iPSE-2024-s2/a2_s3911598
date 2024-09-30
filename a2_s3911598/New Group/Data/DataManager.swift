//
//  DataManager.swift
//  a2_s3911598
//
//  Created by Lea Wang on 29/9/2024.
//
import SwiftData
import SwiftUI

class DataManager {
    static let shared = DataManager()

    private init() {}

    func saveContext(context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

