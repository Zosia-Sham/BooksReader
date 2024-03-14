import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "AuthorEntity")
    }

    @NSManaged public var author: String?

}

extension Author : Identifiable {

}
