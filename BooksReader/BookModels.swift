import UIKit
import SwiftUI


struct BookCardModel: Hashable {
		var image: UIImage?
		var title: String
		var authors: [String] = []
		var tags: [String] = []
		var favourite: Bool = false
}

struct BookModel: Hashable {
		var mainInfo: BookCardModel
		var description: String?
		var pdfModel: PDFModel
}

struct PDFModel: Hashable {
		var numOfPages: Int?
		var textURL: URL?
		var mark: Int = 0
}

