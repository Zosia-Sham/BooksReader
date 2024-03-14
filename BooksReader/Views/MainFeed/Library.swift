import SwiftUI


struct Library: View {
		@Environment(\.colorScheme) private var scheme
		@State private var path = [BookInfoModel]()
		
		@Environment(\.managedObjectContext) private var viewContext
		@FetchRequest(sortDescriptors: []) private var books: FetchedResults<BookInfoModel>
		
		var filteredBooks: [BookInfoModel] {
				if name == "Моя библиотека" {
						return books.filter { b in return true }
				}
				return books.filter { return $0.favourite }
		}
		
		var name: String = "Моя библиотека"
		init(name: String = "Моя библиотека") {
				self.name = name
		}
		
		var body: some View {
				NavigationStack(path: $path) {
						VStack(alignment: .leading, spacing: 10) {
								HStack {
										Text(name)
												.padding(.leading, 12)
												.fontWeight(.bold)
												.font(.largeTitle)
										Spacer()
										NavigationLink {
												Settings(scheme)
										} label: {
												Image(systemName: "gear")
														.padding(.trailing, 12)
														.font(.largeTitle)
										}
								}
								ScrollView(.vertical, showsIndicators: false) {
										VStack(spacing: 0) {
												ForEach(filteredBooks, id: \.title) { book in
														BookCard(book.makeUIModel().mainInfo)
																.onTapGesture {
																		path.append(book)
																}
												}
												.navigationDestination(for: BookInfoModel.self) { book in
														BookView(book)
												}
										}
								}
						}
						.overlay(alignment: .bottomTrailing) {
								NavigationLink {
										AddEditView(nil, name: "Добавить книгу")
								} label: {
										Image(systemName: "plus.circle")
												.padding(24)
												.font(.system(size: 48))
												.foregroundColor(.accentColor)
								}
						}
				}
				.foregroundColor(.primary)
		}

}
