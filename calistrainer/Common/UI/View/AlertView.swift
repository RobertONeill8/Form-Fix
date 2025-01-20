//
//  FinishPracticeAlertView.swift
//  calistrainer
//
//   on 20/04/22.
//

import SwiftUI

struct AlertView: View {

	let title: String
	let leftButtonLabel: String
	let rightButtonLabel: String
	let leftButtonAction: () -> Void
	let rightButtonAction: () -> Void

	var body: some View {
		VStack {
			Spacer()
			VStack {
				Text(title)
					.font(.title2)
					.fontWeight(.semibold)
					.foregroundColor(.white)
					.padding()
				Spacer()
				HStack {
					Spacer()
					Button {
						leftButtonAction()
					} label: {
						Text(leftButtonLabel)
							.fontWeight(.semibold)
					}
					Spacer()
					Button {
						rightButtonAction()
					} label: {
						Text(rightButtonLabel)
							.fontWeight(.semibold)
							.foregroundColor(Color("PrimaryGray"))
							.padding(.vertical, 10)
							.padding(.horizontal)
							.background(
								RoundedRectangle(cornerRadius: 10)
							)
					}
					Spacer()
				}
				.padding(.bottom)
			}
			.padding()
			.background {
				RoundedRectangle(cornerRadius: 10)
					.foregroundColor(Color("PrimaryGray"))
					.opacity(0.75)
					.frame(maxHeight: .infinity)
			}
			.frame(height: 170)
			.padding()
			Spacer()
		}
	}
}

struct FinishPracticeAlertView_Previews: PreviewProvider {
	static var previews: some View {
		AlertView(title: "test", leftButtonLabel: "one", rightButtonLabel: "two") {

		} rightButtonAction: {

		}
	}
}
