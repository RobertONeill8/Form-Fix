//
//  PracticeProgressViewStyle.swift
//  calistrainer
//
//   on 21/04/22.
//

import SwiftUI

struct PracticeProgressViewStyle: ProgressViewStyle {
	func makeBody(configuration: Configuration) -> some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: UIScreen.main.bounds.size.width, height: 100)
				.foregroundColor(Color("PrimaryGray"))

			Rectangle()
				.frame(width: CGFloat(configuration.fractionCompleted ?? 0) * UIScreen.main.bounds.size.width, height: 100)
				.foregroundColor(.accentColor)
		}
	}
}
