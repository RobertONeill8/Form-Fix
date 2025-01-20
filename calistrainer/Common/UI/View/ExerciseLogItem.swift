//
//  ExerciseLogItem.swift
//  calistrainer
//
//   on 25/05/22.
//

import SwiftUI

struct ExerciseLogItem: View {

	let logItem: LogItem

    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(logItem.exercise)
					.font(.title2)
					.fontWeight(.semibold)
				Spacer()
				Text(practiceTimeText)
					.font(.subheadline)
					.foregroundColor(.gray)
			}.padding()
			Spacer()
			VStack(alignment: .trailing){
				Text(String(logItem.repetitionCount))
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(Color("PrimaryLime"))
				Spacer()
				Text(durationText)
					.font(.subheadline)
					.foregroundColor(.gray)
			}.padding()
		}
		.frame(height: 90)
		.background {
			RoundedRectangle(cornerRadius: 15)
				.foregroundColor(Color("SecondaryGray"))
		}
    }
}

extension ExerciseLogItem {

	var practiceTimeText: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "h:mm a"
		return dateFormatter.string(from: logItem.date)
	}

	var durationText: String {
		switch logItem.durationInSecond {
		case 0..<60:
			return "\(logItem.durationInSecond) seconds"
		default:
			return secondsToMinutesSeconds(logItem.durationInSecond)
		}
	}

	func secondsToMinutesSeconds(_ duration: Int) -> String {
		return "\(duration / 60) minutes \((duration % 60) % 60) seconds"
	}
}

struct ExerciseLogItem_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseLogItem(
			logItem: LogItem(exercise: "The Squats", repetitionCount: 15, date: Date(), durationInSecond: 119)
		)
		.padding()
		.preferredColorScheme(.dark)
    }
}
