import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class MoodViewModelTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var viewModel: MoodViewModel!
    
    @MainActor
    override func setUp() {
        super.setUp()
        // 创建内存中的 ModelContainer，用于测试
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Mood.self, Friend.self, configurations: configuration)
        modelContext = modelContainer.mainContext
        // 初始化 ViewModel
        viewModel = MoodViewModel(modelContext: modelContext)
    }
    
    @MainActor
    override func tearDown() {
        // 清理
        viewModel = nil
        modelContext = nil
        modelContainer = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchMoodData() {
        // 准备测试数据
        let mood1 = Mood(date: Date(), moodLevel: "Pleasant", notes: "Feeling good")
        let mood2 = Mood(date: Date().addingTimeInterval(-86400), moodLevel: "Unpleasant", notes: "Had a bad day")
        modelContext.insert(mood1)
        modelContext.insert(mood2)
        try! modelContext.save()
        
        // 执行方法
        viewModel.fetchMoodData()
        
        // 断言
        XCTAssertEqual(viewModel.moodData.count, 2)
        XCTAssertEqual(viewModel.moodData[0].moodLevel, "Pleasant") // 检查排序是否正确
    }
    
   
    
    @MainActor
    func testMoodForToday() {
        // 准备测试数据
        let todayMood = Mood(date: Date(), moodLevel: "Neutral", notes: "Just okay")
        let yesterdayMood = Mood(date: Date().addingTimeInterval(-86400), moodLevel: "Pleasant", notes: "Great day")
        modelContext.insert(todayMood)
        modelContext.insert(yesterdayMood)
        try! modelContext.save()
        
        // 重新获取数据
        viewModel.fetchMoodData()
        
        // 执行方法
        let mood = viewModel.moodForToday()
        
        // 断言
        XCTAssertNotNil(mood)
        XCTAssertEqual(mood?.moodLevel, "Neutral")
        XCTAssertEqual(mood?.notes, "Just okay")
    }
    
    func testGetMoodDescription() {
        // 测试已知的心情描述
        XCTAssertEqual(viewModel.getMoodDescription(for: "Pleasant"), "Pleasant")
        XCTAssertEqual(viewModel.getMoodDescription(for: "Very Unpleasant"), "Very Unpleasant")
        
        // 测试未知的心情描述
        XCTAssertEqual(viewModel.getMoodDescription(for: "Unknown Mood"), "Unknown")
    }
}
