//
//  DateButton.swift
//  calistrainer
//
//   on 25/05/22.
//

import SwiftUI

struct DateButton: View {

	let date: Date
	var buttonState: ButtonState = .enabled
	let action: () -> Void

    var body: some View {
		Button {
			action()
		} label: {
			VStack(spacing: 10) {
				Text(dayLabel)
				Text(dateLabel)
					.fontWeight(.semibold)
			}
			.foregroundColor(textColor)
			.padding(.vertical)
			.frame(width: 60)
			.background {
				Capsule()
					.foregroundColor(backgroundColor)
			}
		}
    }
}

extension DateButton {

	var dayLabel: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "E"
		return dateFormatter.string(from: date)
	}

	var dateLabel: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d"
		return dateFormatter.string(from: date)
	}

	var backgroundColor: Color {
		switch buttonState {
		case .active:
			return Color("PrimaryLime")
		case .disabled:
			return Color("PrimaryGray")
		case .enabled:
			return Color("LightGray")
		}
	}

	var textColor: Color {
		switch buttonState {
		case .active:
			return Color("PrimaryGray")
		case .disabled:
			return .gray.opacity(0.5)
		case .enabled:
			return .primary
		}
	}

	enum ButtonState {
		case active
		case disabled
		case enabled
	}
}

struct DateButton_Previews: PreviewProvider {
    static var previews: some View {
		DateButton(date: Date(), buttonState: .active, action: {})
			.preferredColorScheme(.dark)
    }
}
