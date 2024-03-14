import SwiftUI
import MapKit


struct AboutView: View {
		
		@State private var region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		let markers: [Marker] = [Marker(marker: MapMarker(coordinate: location))]
		
		var body: some View {
				VStack(spacing: 0) {
						VStack {
								LabeledContent("Автор", value: "Зося Шамина")
								LabeledContent("Почта", value: "zashamina@edu.hse.ru")
								LabeledContent("Адрес", value: "Покровский б-р, 11с1")
						}
						.padding(.horizontal, 24)
						
						Map(coordinateRegion: $region, annotationItems: markers) { marker in
								marker.marker
						}
						.cornerRadius(16)
						.frame(height: 400)
						.padding(24)
				}
				.navigationTitle("Об авторе")
				.toolbar(.hidden, for: .tabBar)
		}
}

struct Marker: Identifiable {
		let id = UUID()
		var marker: MapMarker
}

let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.754471, longitude: 37.649139)

