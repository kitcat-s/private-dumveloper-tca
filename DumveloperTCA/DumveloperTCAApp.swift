//
//  DumveloperTCAApp.swift
//  DumveloperTCA
//
//  Created by Kitcat Seo on 9/19/25.
//

import SwiftUI
import SwiftData

@main
struct DumveloperTCAApp: App {
    var body: some Scene {
        WindowGroup {
            MypageView()
        }
        .modelContainer(modelContainer)
    }
}

private var modelContainer: ModelContainer = {
    let schema = Schema([User.self])
    let modelConfiguration = ModelConfiguration(schema: schema)

    do {
        let container = try ModelContainer(for: schema, configurations: modelConfiguration)
        Task { @MainActor in
            setInitialData(context: container.mainContext)
        }
        
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("ModelContiner 생성 실패: \(error)")
    }
}()

private func setInitialData(context: ModelContext) {
    let descriptor = FetchDescriptor<User>()
    if let isEmpty = try? context.fetch(descriptor).isEmpty, isEmpty {
        let user = User(name: "홍길동", email: "Hong@a.com", imageData: nil)
        context.insert(user)
        try? context.save()
    }
}
