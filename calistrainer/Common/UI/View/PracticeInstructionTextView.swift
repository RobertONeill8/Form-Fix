//
//  PracticeInstructionTextView.swift
//  calistrainer
//
//   on 22/04/22.
//

import SwiftUI

struct PracticeInstructionTextView: View {

	let exercise: Exercise
	let stage: ExerciseStage
	let previousStage: ExerciseStage?
	
	@State private var animationAmount = 1.0
	@State var isShaking = false

	let audioManager = AudioManager.shared

	var body: some View {
		switch stage {
		case .neutral:
			Text(ExerciseStage.promptString(exercise: exercise, stage: stage))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(.accentColor)
				.tracking(8)
				.textBorder(color: Color("PrimaryGray"), borderWidth: 8)
				.onAppear {
					if previousStage == .contracting {
						audioManager.playSound(sound: "fail", type: "wav")
					}
					withAnimation(.linear(duration: 0.2)) {
						isShaking.toggle()
					}
				}
				.modifier(ShakeEffect(animatableData: CGFloat(isShaking ? 1 : 0)))

		case .contracting:
			Text(ExerciseStage.promptString(exercise: exercise, stage: stage))
				.font(.title2)
				.fontWeight(.bold)
				.foregroundColor(.accentColor)
				.tracking(10)
				.textBorder(color: Color("PrimaryGray"), borderWidth: 8)
				.scaleEffect(animationAmount)
				.animation(.easeOut(duration: 2), value: animationAmount)
				.onAppear {
					audioManager.playSound(sound: "buildup", type: "wav")
					withAnimation(.linear(duration: 0.2)) {
						isShaking.toggle()
						animationAmount += 1
					}
				}
				.onDisappear {
					animationAmount -= 1
				}
				.modifier(ShakeEffect(animatableData: CGFloat(isShaking ? 1 : 0)))

		case .returning:
			Text(ExerciseStage.promptString(exercise: exercise, stage: stage))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(.accentColor)
				.tracking(10)
				.textBorder(color: Color("PrimaryGray"), borderWidth: 8)
				.onAppear {
					audioManager.playSound(sound: "bell", type: "wav")
					withAnimation(.linear(duration: 0.2)) {
						isShaking.toggle()
					}
				}
				.onDisappear {
					audioManager.playSound(sound: "slap", type: "wav")
				}
				.modifier(ShakeEffect(animatableData: CGFloat(isShaking ? 1 : 0)))
		}
	}
}
