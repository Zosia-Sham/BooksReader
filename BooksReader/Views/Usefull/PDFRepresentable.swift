import SwiftUI
import PDFKit


struct PDFKitView: View {
		
		@AppStorage("displayModeKey") private var displayMode: DisplayMode = .singlePage
		
		var pdfModel: PDFModel
		init(_ pdfModel: PDFModel) {
				self.pdfModel = pdfModel
		}
		
		var body: some View {
				if pdfModel.textURL != nil {
						PDFKitRepresentedView(pdfModel, displayMode)
				} else {
						Text("Пожалуйста добавьте пдф файл")
				}
		}
}

struct PDFKitRepresentedView: UIViewRepresentable {
		
		let pdfModel: PDFModel
		let displayMode: DisplayMode

		init(_ pdfModel: PDFModel,
				 _ displayMode: DisplayMode) {
				self.pdfModel = pdfModel
				self.displayMode = displayMode
		}

		func makeUIView(context: Context) -> UIView {
				guard let document = PDFDocument(url: self.pdfModel.textURL!) else { return UIView() }
				
				let pdfView = PDFView()
				pdfView.document = document
				pdfView.displayMode = self.displayMode.pdf
				switch self.displayMode.pdf {
						case .singlePage:
								pdfView.displayDirection = .horizontal
								pdfView.usePageViewController(true)
						case .twoUp:
								pdfView.displayDirection = .horizontal
								pdfView.usePageViewController(true)
						case .singlePageContinuous, .twoUpContinuous:
								pdfView.displayDirection = .vertical
								pdfView.usePageViewController(false)
						@unknown default:
								pdfView.displayDirection = .vertical
								pdfView.usePageViewController(false)
				}
				pdfView.autoScales = true

				return pdfView
		}

		func updateUIView(_ uiView: UIView, context: Context) {
				guard let pdfView = uiView as? PDFView else { return }
				
				if pdfModel.mark < pdfModel.numOfPages ?? 0 {
						pdfView.go(to: pdfView.document!.page(at: pdfModel.mark)!)
				}
		}
}
