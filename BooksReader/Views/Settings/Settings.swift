import SwiftUI
import PDFKit

enum Theme: String, CaseIterable {
		case light = "светлая"
		case dark = "темная"
		case system = "системная"
		
		var colorScheme: ColorScheme? {
				switch self {
						case .light:
								return ColorScheme.light
						case .dark:
								return ColorScheme.dark
						case .system:
								return nil
				}
		}
}

enum DisplayMode: String, CaseIterable {
		case singleScroll = "одна страница со скроллом"
		case singlePage = "одна страница на экране"
		case twoScroll = "две страницы со скроллом"
		case twoPage = "две страницы на экране"
		
		var pdf: PDFDisplayMode {
				switch self {
						case .singleScroll:
								return PDFDisplayMode.singlePageContinuous
						case .singlePage:
								return PDFDisplayMode.singlePage
						case .twoScroll:
								return PDFDisplayMode.twoUpContinuous
						case .twoPage:
								return PDFDisplayMode.twoUp
				}
		}
}

struct Settings: View {
		
		@AppStorage("themeKey") private var theme: Theme = .system
		@AppStorage("displayModeKey") private var displayMode: DisplayMode = .singlePage
		
		private var scheme: ColorScheme
		
		init(_ scheme: ColorScheme) {
				self.scheme = scheme

		}
		
		
		var body: some View {
				Form {
						Section(header: Text("Основные настройки")) {
								
								Picker("Тема", selection: $theme) {
										ForEach(Theme.allCases, id: \.self) {
												Text($0.rawValue)
										}
								}
								Picker("Перелистывание", selection: $displayMode) {
										ForEach(DisplayMode.allCases, id: \.self) {
												Text($0.rawValue)
										}
								}
						}
						
						Section(header: Text("О приложении")) {
								NavigationLink {
										AboutView()
								} label: {
										LabeledContent("Об авторе") {
												Image(systemName: "info.circle.fill")
														.foregroundColor(.secondary)
										}
								}
								LabeledContent("version") {
										Text("0.1.0v")
												.foregroundColor(.secondary)
								}
						}
				}
				.navigationTitle("Настройки")
				.environment(\.colorScheme, scheme)
				.toolbar(.hidden, for: .tabBar)
		}
}

