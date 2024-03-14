import SwiftUI


struct Onboarding: View {
		
		@Environment(\.dismiss) private var dismiss
		@AppStorage("onboard") private var onboard: Bool = true
		
		@State var features1: [MiniCard] = [
				.init(string: "Можно загружать и просматривать pdf-книги"),
				.init(string: "Можно настривать как угодно теги, обложку и описание книг"),
				.init(string: "Можно настраивать тему приложения"),
				.init(string: "Удобное окно избранное")
		]
		@State var features2: [MiniCard] = [
				.init(string: "SwiftUI"), .init(string: "MVVM"),
				.init(string: "CoreData"), .init(string: "и немножко UserDefaults"),
				.init(string: "PhotosUI"), .init(string: "PDFKit"), .init(string: "MapKit"),
				.init(string: "пол бюджета на анимацию"), .init(string: "обертка над UIKit")
		]
		
		
		@State private var tabbarSelected: Int = 0
		
		var body: some View {
				TabView(selection: $tabbarSelected) {
						makeZero()
								.tag(0)
						makeFirst()
								.tag(1)
						makeSecond()
								.tag(2)
						makeThird()
								.tag(3)
				}
				.tabViewStyle(.page(indexDisplayMode: .never))
		}
		
		@ViewBuilder
		private func makeZero() -> some View {
				VStack {
						Spacer()
						Text("Приложение Читалка")
								.font(.largeTitle)
						Spacer()
						Button {
								tabbarSelected = 1
						} label : {
								Text("Далее")
						}
				}
		}
		
		@ViewBuilder
		private func makeFirst() -> some View {
				ZStack(alignment: .bottom) {
						VStack {
								Spacer()
								HStack {
										Text("Features")
												.font(.largeTitle)
												.padding(.horizontal, 32)
										Spacer()
								}
								ForEach(features1, id: \.string) { str in
										if str.animated {
												Text(str.string)
														.padding(10)
														.frame(width: 330, height: 70)
														.background(.tertiary)
														.cornerRadius(12)
										}
								}
								Spacer()
						}
						.onAppear {
								for index in 0..<4 {
										DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
												withAnimation(.easeInOut(duration: 0.5)) {
														features1[index].animated = true
												}
										}
								}
						}
						Button {
								tabbarSelected = 2
						} label : {
								Text("Далее")
						}
				}
		}
		
		@ViewBuilder
		private func makeSecond() -> some View {
				var width = CGFloat.zero
				var height = CGFloat.zero
				
				ZStack(alignment: .bottom) {
						GeometryReader { proxy in
								VStack(alignment: .leading, spacing: 0) {
										Text("Stack")
												.font(.largeTitle)
												.padding(.top, 180)
										
										ZStack(alignment: .topLeading) {
												ForEach(features2, id: \.string) { tag in
														if tag.animated {
																Text(tag.string)
																		.padding(.horizontal, 16)
																		.frame(height: 40)
																		.background(.tertiary)
																		.cornerRadius(6)
																		.alignmentGuide(.leading) { d in
																				if (abs(width - d.width - 10) > proxy.size.width) {
																						width = 0
																						height -= d.height + 10
																				}
																				let result = width
																				if tag.string == features2.last!.string {
																						width = 0
																				} else {
																						width -= d.width + 10
																				}
																				return result
																		}
																		.alignmentGuide(.top) { d in
																				let result = height
																				if tag.string == features2.last!.string {
																						height = 0
																				}
																				return result
																		}
														}
												}
										}
										.padding(.top, 220)
								}
								.padding(.horizontal, 24)
						}
						.onAppear {
								for index in 0..<9 {
										DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
												withAnimation(.easeInOut(duration: 0.4)) {
														features2[index].animated = true
												}
										}
								}
						}
						Button {
								tabbarSelected = 3
						} label : {
								Text("Далее")
						}
				}
		}
		
		@ViewBuilder
		private func makeThird() -> some View {
						
				Button {
						onboard.toggle()
						dismiss()
				} label : {
						Text("Начнем!")
								.font(.title)
								.frame(width: 150, height: 60)
								.background(.tertiary)
								.cornerRadius(6)
				}
		}
		
}

struct MiniCard {
		var animated: Bool = false
		let string: String
}

