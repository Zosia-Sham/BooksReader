import SwiftUI


struct BookIcon: View {
		private var book: BookCardModel
		init(_ book: BookCardModel) {
				self.book = book
		}
		var body: some View {
				VStack(spacing: 0) {
						Color.purple
						VStack {
								Text(book.title)
										.multilineTextAlignment(.center)
										.fontWeight(.bold)
										.font(.system(size: 20))
										.fontWidth(.compressed)
										.fixedSize(horizontal: false, vertical: true)
								Text(book.authors.first ?? "")
										.fontWeight(.light)
										.font(.system(size: 12))
										.fontWidth(.compressed)
						}
						.frame(maxWidth: .infinity)
						.background(.background)
						Color.purple
				}
		}
}

struct MakeBookIcon: View {
		private var book: BookCardModel
		init(_ book: BookCardModel) {
				self.book = book
		}
		var body: some View {
				if let uiimage = book.image {
						Image(uiImage: uiimage)
								.resizable()
								.scaledToFit()
				} else {
						BookIcon(book)
				}
		}
}
