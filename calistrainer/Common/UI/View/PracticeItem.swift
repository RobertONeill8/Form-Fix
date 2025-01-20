//
//  PracticeItem.swift
//  calistrainer
//
//   on 15/03/22.
//

import SwiftUI

struct PracticeItem: View {

	let exerciseItem: HomeExerciseItem

    var body: some View {
		VStack {
			Spacer()
			Image(exerciseItem.image)
				.resizable()
				.scaledToFit()
				.clipShape(RoundedRectangle(cornerRadius: 20))
				.mask {
					LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .center, endPoint: .bottom)
				}

			VStack(spacing: 10) {
				Text(exerciseItem.exercise.rawValue)
					.font(.title)
					.fontWeight(.bold)
				Text(exerciseItem.description)
			}.padding()
			Spacer()
			
		}
    }
}

struct PracticeItem_Previews: PreviewProvider {
    static var previews: some View {
        PracticeItem(exerciseItem: HomeExerciseItem(
			exercise: .squat,
			description: "Train your legs",
			image: "Squat",
			isSideFacing: false
		))
    }
}
