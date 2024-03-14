import SwiftUI
import UIKit


struct ContentView: View {
		
		@AppStorage("themeKey") private var theme: Theme = .system
		@AppStorage("onboard") private var onboard: Bool = true
		
    var body: some View {
				ZStack {
						TabView {
								Library()
										.tabItem {
												Label("Библиотека", systemImage: "books.vertical")
										}
								Library(name: "Избранное")
										.tabItem {
												Label("Избранное", systemImage: "star")
										}
						}
						.preferredColorScheme(theme.colorScheme)
						
						if onboard {
								Onboarding()
										.background(.background)
										.ignoresSafeArea()
						}
				}
    }
}
