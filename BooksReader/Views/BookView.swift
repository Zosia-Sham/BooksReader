import SwiftUI


struct BookView: View {
		
		@Environment(\.managedObjectContext) private var viewContext
		@Environment(\.dismiss) private var dismiss
		
		@State var book: BookModel
		var storageModel: BookInfoModel
		
		init(_ book: BookInfoModel) {
				_book = State(initialValue: book.makeUIModel())
				storageModel = book
		}
		
		var body: some View {
				GeometryReader { proxy in
						VStack(spacing: 10) {
								ScrollView {
										MakeBookIcon(book.mainInfo)
												.blur(radius: 7)
												.opacity(0.7)
												.scaledToFill()
												.frame(height: 402)
												.frame(maxWidth: proxy.size.width)
												.clipped()
												.overlay(alignment: .center) {
														MakeBookIcon(book.mainInfo)
																.frame(width: 268, height: 402)
												}
										VStack(alignment: .leading) {
												Text(book.mainInfo.title)
														.fontWeight(.semibold)
														.font(.system(size: 20))
												Text(book.mainInfo.authors.joined(separator: ", "))
														.foregroundColor(.secondary)
												if book.mainInfo.tags.count > 0 {
														Text("Теги:")
																.padding(.top, 16)
																.fontWeight(.medium)
														TagsView(book.mainInfo.tags)
																.fixedSize(horizontal: false, vertical: true)
																.padding(.top, 10)
												}
												
												if let description = book.description,
													 description.count > 0 {
														Text("Описание:")
																.padding(.top, 16)
																.fontWeight(.medium)
														Text(description)
																.fixedSize(horizontal: false, vertical: true)
												}
										}
										.padding(.horizontal, 20)
										.multilineTextAlignment(.leading)
								}
								
								NavigationLink {
										PDFKitView(book.pdfModel)
								} label: {
										if book.pdfModel.mark > 0 {
												Text("Продолжить с \(book.pdfModel.mark) страницы")
										} else {
												Text("Начать читать")
										}
								}
						}
				}
				.edgesIgnoringSafeArea(.top)
				.toolbar {
						Button {
								book.mainInfo.favourite.toggle()
								storageModel.favourite.toggle()
								try? viewContext.save()
						} label: {
								if book.mainInfo.favourite {
										Image(systemName: "star.fill")
												.foregroundColor(.yellow)
												.font(.largeTitle)
								} else {
										Image(systemName: "star")
												.font(.largeTitle)
								}
						}
						Menu {
								NavigationLink {
										AddEditView(storageModel, name: "Редактировать книгу")
								} label: {
										LabeledContent {
												Text("Редактировать")
										} label: {
												Image(systemName: "square.and.pencil")
										}
								}
								Button {
										viewContext.delete(storageModel)
										try? viewContext.save()
										dismiss()
								} label: {
										LabeledContent {
												Text("Удалить")
														.foregroundColor(.red)
										} label: {
												Image(systemName: "trash")
														.foregroundColor(.red)
										}
								}
								
						} label: {
								Image(systemName: "pencil")
										.font(.largeTitle)
						}
				}
				.toolbarBackground(.hidden, for: .navigationBar)
				.toolbar(.hidden, for: .tabBar)
				.onAppear {
						refreshData()
				}
		}
		
		private func refreshData() {
				book = storageModel.makeUIModel()
		}
}
