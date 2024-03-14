import SwiftUI

// Big thanks for:
// https://stackoverflow.com/questions/58842453/swiftui-hstack-with-wrap/58876712#58876712

struct TagsView: View {
		
		private var tags: [String]
		private var editable: Bool
		private var completion: ([String]) -> Void
		init(_ tags: [String],
				 editable: Bool = false,
				 completion: @escaping ([String]) -> Void = { b in return }
		) {
				self.tags = tags
				self.editable = editable
				self.completion = completion
		}
		
		var body: some View {
				GeometryReader { geometry in
						self.generateContent(in: geometry)
				}
		}

		private func generateContent(in proxy: GeometryProxy) -> some View {
				var width = CGFloat.zero
				var height = CGFloat.zero
				var maxHeight = CGFloat.zero

				return ZStack(alignment: .topLeading) {
						ForEach(self.tags, id: \.self) { tag in
								self.item(for: tag)
										.padding(4)
										.alignmentGuide(.leading) { d in
												if (abs(width - d.width) > proxy.size.width) {
														width = 0
														height -= d.height
												}
												let result = width
												if tag == self.tags.last! {
														width = 0
												} else {
														width -= d.width
												}
												return result
										}
										.alignmentGuide(.top) { d in
												let result = height
												if tag == self.tags.last! {
														maxHeight = -height + d.height
														height = 0
												}
												return result
										}
						}
				}
				.frame(minHeight: maxHeight)
		}

		private func item(for text: String) -> some View {
				Text(text)
						.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
						.background(.tertiary)
						.cornerRadius(12)
						.onTapGesture {
								if editable {
										completion(tags.filter { elem in
												return elem != text
										})
								}
						}
		}
}
