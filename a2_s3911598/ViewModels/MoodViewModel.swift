//
//  MoodViewModel.swift
//  a2_s3911598
//
//  Created by Lea Wang on 11/10/2024.
//
//
//import SwiftUI
//import SwiftData
//
//class MoodViewModel: ObservableObject {
//    @Published var moodData: [Mood] = []
//    @Published var friends: [Friend] = []
//
//    private var modelContext: ModelContext
//
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        fetchMoodData()
//        fetchFriends()
//    }
//
//    // 获取情绪数据
//    func fetchMoodData() {
//        let fetchDescriptor = FetchDescriptor<Mood>(sortBy: [SortDescriptor(\.date, order: .reverse)])
//        do {
//            moodData = try modelContext.fetch(fetchDescriptor)
//        } catch {
//            print("Failed to fetch mood data: \(error)")
//            moodData = []
//        }
//    }
//
//    // 获取好友数据
//    func fetchFriends() {
//        let fetchDescriptor = FetchDescriptor<Friend>()
//        do {
//            friends = try modelContext.fetch(fetchDescriptor)
//        } catch {
//            print("Failed to fetch friends: \(error)")
//            friends = []
//        }
//    }
//
//    // 获取今天的心情记录
//    func moodForToday() -> Mood? {
//        return moodData.first(where: { Calendar.current.isDateInToday($0.date) })
//    }
//
//    // 获取心情描述
//    func getMoodDescription(for mood: String) -> String {
//        switch mood {
//        case "Very Unpleasant": return "Very Unpleasant"
//        case "Unpleasant": return "Unpleasant"
//        case "Neutral": return "Neutral"
//        case "Pleasant": return "Pleasant"
//        case "Slightly Pleasant": return "Slightly Pleasant"
//        case "Very Pleasant": return "Very Pleasant"
//        default: return "Unknown"
//        }
//    }
//}

