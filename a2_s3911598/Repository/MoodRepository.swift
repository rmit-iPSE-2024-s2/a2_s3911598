import SwiftData
import Foundation
import Combine

class MoodRepository: ObservableObject {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
    
    //add mood record
    func addMood(date: Date = Date(), moodLevel: String, notes: String = "", sharedWith: [String] = []) {
        let newMood = Mood(date: date, moodLevel: moodLevel, notes: notes, sharedWith: sharedWith)
        context.insert(newMood)
        
        // 保存上下文，确保数据被持久化
        saveContext()  // 这行是关键，确保数据持久保存
    }
    
    // 获取所有情绪记录，按日期排序
    func getAllMoods() -> [Mood] {
        let fetchDescriptor = FetchDescriptor<Mood>(
            sortBy: [SortDescriptor(\Mood.date, order: .reverse)]
        )
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch moods: \(error)")
            return []
        }
    }
    
    // 获取所有情绪数据
    func fetchAllMoods() -> [Mood] {
        return getAllMoods()
    }
    
    // 删除情绪记录
    func deleteMood(_ mood: Mood) {
        context.delete(mood)
        saveContext()
    }
    
    // 保存上下文
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
