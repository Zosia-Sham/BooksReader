import SwiftUI
import UIKit
import PDFKit
import PhotosUI


struct AddEditView: View {
		@Environment(\.managedObjectContext) private var viewContext
		@Environment(\.dismiss) private var dismiss
		
		private var managedModel: BookInfoModel?
		private let name: String

		@State private var pickerIsPresented: Bool = false
		@State private var imageDisplayed: UIImage?
		@State private var titleDisplayed: String
		@State private var descriptionDisplayed: String
		@State private var authorsDisplayed: [String]
		@State private var author: String = ""
		@State private var tagsDisplayed: [String]
		@State private var tag: String = ""
		@State private var docIsPresented: Bool = false
		@State private var docURL: String?
		
		init(_ managedModel: BookInfoModel?, name: String) {
				self.managedModel = managedModel
				self.name = name
				self._imageDisplayed = State(initialValue: managedModel?.image)
				self._titleDisplayed = State(initialValue: managedModel?.title ?? "")
				self._descriptionDisplayed = State(initialValue: managedModel?.annotation ?? "")
				let tmp = (managedModel?.authors?.array as? [Author]) ?? [Author]()
				self._authorsDisplayed = State(initialValue: tmp.map{ return $0.author ?? "" } )
				let tmp1 = (managedModel?.tags?.array as? [Tag]) ?? [Tag]()
				self._tagsDisplayed = State(initialValue: tmp1.map{ return $0.tag ?? "" } )
				self._docURL = State(initialValue: managedModel?.textURL)
		}
		
		var body: some View {
				GeometryReader { proxy in
						ScrollView {
								VStack(alignment: .leading, spacing: 12) {
										HStack {
												if let imageDisplayed {
														Image(uiImage: imageDisplayed)
																.resizable()
																.scaledToFit()
																.cornerRadius(12)
																.frame(width: 100, height: 150)
												} else {
														Image(systemName: "text.below.photo")
																.frame(width: 100, height: 150)
																.background(Color.secondary)
																.cornerRadius(12)
												}
												VStack {
														Button {
																pickerIsPresented = true
														} label: {
																Text("Загрузить фотографию")
																		.padding(10)
																		.background(.tertiary)
																		.cornerRadius(12)
														}
														.editImage(isPresented: $pickerIsPresented, image: $imageDisplayed)
														if imageDisplayed != nil {
																Button {
																		imageDisplayed = nil
																} label: {
																		Text("Удалить фотографию")
																				.padding(10)
																				.background(.red.opacity(0.8))
																				.cornerRadius(12)
																}
														}
												}
										}
										.padding(12)
										TextField("Название книги", text: $titleDisplayed, axis: .vertical)
												.lineLimit(1...10)
												.autocorrectionDisabled()
												.padding(12)
										TextField("Опсание книги", text: $descriptionDisplayed, axis: .vertical)
												.lineLimit(1...15)
												.autocorrectionDisabled()
												.padding(12)
										
										TagsView(authorsDisplayed, editable: true, completion: { val in
												authorsDisplayed = val
										})
												.padding(.vertical, 20)
												.padding(.horizontal, 12)
												.fixedSize(horizontal: false, vertical: true)
										
										TextField("Автор", text: $author)
												.autocorrectionDisabled()
												.padding(12)
										Button {
												if authorsDisplayed.count < 8 {
														if author.count > 0 {
																authorsDisplayed.append(author)
																author = ""
														}
												} else {
														author = "Слишком много авторов"
												}
										} label: {
												Label("Добавить автора", systemImage: "plus")
														.padding(.horizontal, 12)
														.padding(.vertical, 8)
										}
										.background(.tertiary)
										.cornerRadius(16)
												.frame(maxWidth: .infinity)
										
										TagsView(tagsDisplayed, editable: true, completion: { val in
												tagsDisplayed = val
										})
												.padding(.vertical, 20)
												.padding(.horizontal, 12)
												.fixedSize(horizontal: false, vertical: true)
										TextField("Тег", text: $tag)
												.autocorrectionDisabled()
												.padding(12)
										Button {
												if tagsDisplayed.count < 8 {
														if tag.count > 0 {
																tagsDisplayed.append(tag)
																tag = ""
														}
												} else {
														tag = "Слишком много тегов"
												}
										} label: {
												Label("Добавить тег", systemImage: "plus")
														.padding(.horizontal, 12)
														.padding(.vertical, 8)
										}
										.background(.tertiary)
										.cornerRadius(16)
										.frame(maxWidth: .infinity)
										
										if managedModel?.textURL == nil {
												Button {
														docIsPresented = true
												} label: {
														Label("Добавить текст", systemImage: "plus")
																.padding(.horizontal, 12)
																.padding(.vertical, 8)
												}
												.fileImporter(
														isPresented: $docIsPresented,
														allowedContentTypes: [.appleScript, .pdf, .plainText, .epub],
														allowsMultipleSelection: false
												) { res in
														switch res {
																case .success(let files):
																		if files.count > 0 {
																				docURL = files.first!.absoluteString
																		}
																case .failure(let err):
																		let err = err as NSError
																		fatalError("ERROR: \(err), \(err.userInfo)")
														}
												}
												
												if docURL != nil {
														Text("файл загружен!")
																.padding(.horizontal, 12)
												}
										}
								}
						}
				}
				.navigationTitle(name)
				.toolbar(.hidden, for: .tabBar)
				.toolbar {
						ToolbarItem(placement: .navigationBarTrailing) {
								Button {
										
										guard titleDisplayed.count > 0,
													let docURL = docURL else {
												return
										}
										
										makeObject(docURL)
										
										dismiss()
								} label: {
										Image(systemName: "checkmark")
												.font(.callout)
												.fontWeight(.semibold)
								}
						}
				}
		}
		
		private func makeObject(_ url: String) {
				
				let arrayAuthors: [Author] = authorsDisplayed.map { author in
						let entity =  Author(entity: Author.entity(), insertInto: viewContext)
						entity.author = author
						return entity
				}
				let arrayTags: [Tag] = tagsDisplayed.map { tag in
						let entity =  Tag(entity: Tag.entity(), insertInto: viewContext)
						entity.tag = tag
						return entity
				}
				
				let old = managedModel
				let new: BookInfoModel = BookInfoModel(entity: BookInfoModel.entity(), insertInto: viewContext)
				new.image = imageDisplayed
				new.tags = NSOrderedSet(array: arrayTags)
				new.authors = NSOrderedSet(array: arrayAuthors)
				new.title = titleDisplayed
				new.favourite = managedModel?.favourite ?? false
				new.annotation = descriptionDisplayed
				new.textURL = docURL
				new.mark = managedModel?.mark ?? 0

				
				DispatchQueue.main.async {
						let doc = PDFDocument(url: URL(filePath: url))
						new.pages = Int64(doc?.pageCount ?? 0)
						
						if let old {
								let ats = (old.authors?.array as? [Author]) ?? [Author]()
								let tgs = (old.tags?.array as? [Tag]) ?? [Tag]()
								ats.forEach {
										viewContext.delete($0)
								}
								tgs.forEach {
										viewContext.delete($0)
								}
								old.image = new.image
								old.title = new.title
								old.authors = new.authors
								old.tags = new.tags
								old.favourite = new.favourite
								old.annotation = new.annotation
								old.mark = new.mark
								old.textURL = new.textURL
								old.pages = new.pages
								viewContext.delete(new)
						}
						try? viewContext.save()
				}
		}
}
