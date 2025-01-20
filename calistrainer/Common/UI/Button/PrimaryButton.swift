//
//  PrimaryButton.swift
//  calistrainer
//
//   on 15/03/22.
//

import SwiftUI

struct PrimaryButton: View {
	let label: String
	var fullWidth: Bool = false
	var disabled: Bool = false
	let action: () -> Void


    var body: some View {
		Button {
			action()
		} label: {
			Text(label)
				.foregroundColor(
					disabled
					? Color("PrimaryGray")
					: Color("PrimaryGray")
				)
				.fontWeight(.semibold)
				.padding()
				.frame(maxWidth: fullWidth ? .infinity : nil)
				.background(
					RoundedRectangle(cornerRadius: 15)
						.foregroundColor(
							disabled
							? Color("SecondaryGray")
							: Color("PrimaryLime")
						)
				)
		}
		.disabled(disabled)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
		PrimaryButton(label: "Start", disabled: true, action: {})
    }
}
