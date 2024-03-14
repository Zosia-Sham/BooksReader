import CoreData
import UIKit


extension BookInfoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookInfoModel> {
        return NSFetchRequest<BookInfoModel>(entityName: "BookFullInfoModel")
    }

    @NSManaged public var image: UIImage?
    @NSManaged public var title: String
    @NSManaged public var favourite: Bool
    @NSManaged public var annotation: String?
    @NSManaged public var pages: Int64
    @NSManaged public var mark: Int64
    @NSManaged public var textURL: String?
    @NSManaged public var authors: NSOrderedSet?
    @NSManaged public var tags: NSOrderedSet?

}

// MARK: Generated accessors for authors
extension BookInfoModel {

    @objc(addAuthorsObject:)
    @NSManaged public func addToAuthors(_ value: Author)

    @objc(removeAuthorsObject:)
    @NSManaged public func removeFromAuthors(_ value: Author)

    @objc(addAuthors:)
    @NSManaged public func addToAuthors(_ values: NSOrderedSet)

    @objc(removeAuthors:)
    @NSManaged public func removeFromAuthors(_ values: NSOrderedSet)

}

// MARK: Generated accessors for tags
extension BookInfoModel {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSOrderedSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSOrderedSet)

}

extension BookInfoModel : Identifiable {
		
		func makeUIModel() -> BookModel {
				let image: UIImage? = self.image
				let title = self.title
				let authorsarray: [Author]  = self.authors?.array as? [Author] ?? [Author]()
				let authors: [String] = authorsarray.map { author in
						return author.author ?? ""
				}
				let tagsarray: [Tag] = self.tags?.array as? [Tag] ?? [Tag]()
				let tags: [String] = tagsarray.map { tag in
						return tag.tag ?? ""
				}
				let favourite = self.favourite
				let description: String? = self.annotation
				let numOfPages: Int = Int(self.pages)
				let textURL: String? = self.textURL
				let mark: Int = Int(self.mark)
				
				let bookCardModel = BookCardModel(
						image: image,
						title: title,
						authors: authors,
						tags: tags,
						favourite: favourite
				)
								
				let pdfModel = PDFModel(
						numOfPages: numOfPages,
						textURL: URL(string: textURL ?? ""),
						mark: mark
				)
				
				return BookModel(
						mainInfo: bookCardModel,
						description: description,
						pdfModel: pdfModel
				)
		}
}
