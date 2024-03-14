import SwiftUI

@main
struct BooksReaderApp: App {
		
		@StateObject private var storage: CoreStorage = CoreStorage.shared
		
    var body: some Scene {
        WindowGroup {
            ContentView()
								.environment(\.managedObjectContext, storage.container.viewContext)
        }
    }
}
