import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "TagEntity")
    }

    @NSManaged public var tag: String?

}

extension Tag : Identifiable {

}
