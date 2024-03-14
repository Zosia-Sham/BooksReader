import SwiftUI


struct BookCard: View {
		
		var book: BookCardModel
		init(_ book: BookCardModel) {
				self.book = book
		}
		
		var body: some View {
				HStack(spacing: 10) {
						MakeBookIcon(book)
								.cornerRadius(12)
								.frame(width: 100, height: 150)
								.padding(8)
								.shadow(color: .gray, radius: 5, x: 2, y: 2)
						VStack(alignment: .leading) {
								Text(book.title)
										.fontWeight(.semibold)
										.font(.system(size: 20))
								Text(book.authors.joined(separator: ", "))
										.multilineTextAlignment(.leading)
										.foregroundColor(.secondary)
								if book.tags.count > 0 {
										TagsView(book.tags)
												.fixedSize(horizontal: false, vertical: true)
												.padding(.top, 12)
												.opacity(0.3)
								}
						}
						Spacer()
				}
				.overlay(alignment: .bottomTrailing) {
						if book.favourite {
								Image(systemName: "star.fill")
										.foregroundColor(.yellow)
										.padding()
						} else {
								Image(systemName: "star")
										.foregroundColor(.secondary)
										.padding()
						}
				}
		}
}
