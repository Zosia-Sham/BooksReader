import Foundation
import CoreData
import SwiftUI


final class CoreStorage: ObservableObject {
		static let shared = CoreStorage()
		
		let container: NSPersistentContainer
		
		init() {
				container = NSPersistentContainer(name: "BookInfoModel")
				container.viewContext.automaticallyMergesChangesFromParent = true
				container.loadPersistentStores(completionHandler: { (_, error) in
						if let error = error as NSError? {
								fatalError("ERROR: \(error), \(error.userInfo)")
						}
				})
		}
}




