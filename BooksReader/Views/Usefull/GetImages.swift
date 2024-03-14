import UIKit
import SwiftUI
import PhotosUI


extension View {
		@ViewBuilder
		func editImage(isPresented: Binding<Bool>, image: Binding<UIImage?>) -> some View {
				ImagePicker(isPresented: isPresented, image: image) {
						self
				}
		}
}

struct ImagePicker<Content: View>: View {
		private var content: Content
		@Binding private var isPresented: Bool
		@Binding private var image: UIImage?
		
		init(
				isPresented: Binding<Bool>,
				image: Binding<UIImage?>,
				@ViewBuilder content: @escaping () -> Content
		) {
				self.content = content()
				self._isPresented = isPresented
				self._image = image
		}
		
		@State private var imageSelection: PhotosPickerItem?
		@State private var selectedImage: UIImage?
		@State private var showEditable: Bool = false
		
		var body: some View {
				content
						.photosPicker(isPresented: $isPresented, selection: $imageSelection)
						.onChange(of: imageSelection) { img in
								if let img {
										Task {
												if let data = try? await img.loadTransferable(type: Data.self),
													 let image = UIImage(data: data) {
														await MainActor.run(body: {
																selectedImage = image
																showEditable.toggle()
														})
												}
										}
								}
						}
						.fullScreenCover(isPresented: $showEditable, onDismiss: {
								selectedImage = nil
						}) {
								CropView(image: selectedImage) { img, suc in
										if let img {
												self.image = img
										}
								}
						}
		}
}


struct CropView: View {
		
		@Environment(\.dismiss) private var dismiss
		
		private var image: UIImage?
		private var onCrop: (UIImage?, Bool) -> ()
		
		@State private var scale: CGFloat = 1.0
		@State private var lastScale: CGFloat = 0.0
		@State private var offset: CGSize = .zero
		@State private var lastOffset: CGSize = .zero
		@GestureState private var isInteracting: Bool = false
		
		init(image: UIImage?, onCrop: @escaping (UIImage?, Bool) -> ()) {
				self.image = image
				self.onCrop = onCrop
		}
		
		var body: some View {
				NavigationStack {
						ZStack {
								imageView()
										.frame(maxWidth: .infinity, maxHeight: .infinity)
										.background {
												Color.black
																.ignoresSafeArea()
												}
								VStack(spacing: 0) {
										Color.black
												.opacity(0.7)
										HStack(spacing: 0) {
												Color.black
														.opacity(0.7)
												Color.clear
														.frame(width: 200, height: 300)
												Color.black
														.opacity(0.7)
										}
										.frame(height: 300)
										Color.black
												.opacity(0.7)
								}
								.ignoresSafeArea()
						}
						.toolbar {
								ToolbarItem(placement: .navigationBarLeading) {
										Button {
												dismiss()
										} label: {
												Image(systemName: "xmark")
														.font(.callout)
														.fontWeight(.semibold)
														.foregroundColor(.white)
										}
								}
								ToolbarItem(placement: .navigationBarTrailing) {
										Button {
												let renderer = ImageRenderer(content: imageView())
												renderer.proposedSize = .init(CGSize(width: 200, height: 300))
												if let image = renderer.uiImage {
														onCrop(image, true)
												} else {
														onCrop(nil, false)
												}
												dismiss()
										} label: {
												Image(systemName: "checkmark")
														.font(.callout)
														.fontWeight(.semibold)
														.foregroundColor(.white)
										}
								}
						}
				}
		}
		
		@ViewBuilder
		private func imageView() -> some View {
				GeometryReader { proxy in
						let size = proxy.size
						
						if let image {
								Image(uiImage: image)
										.resizable()
										.scaledToFill()
										.overlay {
												GeometryReader { proxy in
														let rect = proxy.frame(in: .named("CROPVIEW"))
														
														Color.clear
																.frame(width: 200, height: 300)
																.onChange(of: isInteracting) { value in
																		
																		withAnimation(.easeInOut(duration: 0.2)) {
																				if rect.minX > 0 {
																						offset.width = offset.width - rect.minX
																				}
																				if rect.minY > 0 {
																						offset.height = offset.height - rect.minY
																				}
																				if rect.maxX < size.width {
																						offset.width = -offset.width + rect.minX
																				}
																				if rect.maxX < size.height {
																						offset.height = -offset.height + rect.minY
																				}
																		}
																		if !value {
																				lastOffset = offset
																		}
																}
																
												}
										}
										.frame(width: size.width, height: size.height)
						}
				}
				.offset(offset)
				.scaleEffect(scale)
				.coordinateSpace(name: "CROPVIEW")
				.gesture(
						DragGesture()
								.updating($isInteracting, body: { _, out, _ in
										out = true
										
								})
								.onChanged { value in
										let translation = value.translation
										offset = CGSize(width: translation.width + lastOffset.width,
																		height: translation.height + lastOffset.height)
								}
				)
				.gesture(
						MagnificationGesture()
								.updating($isInteracting, body: { _, out, _ in
										out = true
								})
								.onChanged { value in
										let updated = value + lastScale
										scale = max(1.0, updated)
								}
								.onEnded { value in
										withAnimation(.easeInOut(duration: 0.2)) {
												if scale < 1 {
														scale = 1
												}
												lastScale = scale - 1
										}
								}
				)
				.frame(width: 200, height: 300)
		}
}

