//
//  StrokedText.swift
//  calistrainer
//
//   on 20/04/22.
//

import SwiftUI

struct TextBorder: ViewModifier {
	let color: Color
	var borderWidth: Int

	func body(content: Content) -> some View {
		applyShadow(content: AnyView(content), borderWidth: borderWidth)
	}

	func applyShadow(content: AnyView, borderWidth: Int) -> AnyView {
		guard borderWidth != 0 else { return content }
		return applyShadow(content: AnyView(content.shadow(color: color, radius: 1)), borderWidth: borderWidth - 1)
	}
}

extension View {
	func textBorder(color: Color, borderWidth: Int) -> some View {
		return self.modifier(TextBorder(color: color, borderWidth: borderWidth))
	}
}

struct TextBorder_Preview: PreviewProvider {
	static var previews: some View {
		Text("HOLD")
			.font(.largeTitle)
			.bold()
			.foregroundColor(.accentColor)
			.tracking(10)
			.textBorder(color: Color("PrimaryGray"), borderWidth: 8)
	}
}
