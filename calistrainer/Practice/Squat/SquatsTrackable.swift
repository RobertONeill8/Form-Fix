//
//  SquatsTrackable.swift
//  calistrainer
//
//

import Foundation
import Combine
import Vision

final class SquatsTrackable: ExerciseTrackable {

	var repetitionCount = 0
	var currentExerciseStage: ExerciseStage = .neutral
	var previousExerciseStage: ExerciseStage?
	var postureError = PostureError()
	var cameraPerspective: CameraPerspective?

	private var holdTimer: Timer?
	private var holdCount = 0

	private var loweringHipTimer: Timer?
	private var loweringHipCounter = 0

	let speechSynthesizer = SpeechSynthesizer()

	func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {

		self.assertFeetInlineWithFeet(bodyParts: bodyParts)
		self.assertHorizontallyInlineShoulders(bodyParts: bodyParts)
		self.assertThighsWithGroundParalellity(bodyParts: bodyParts)

		// declare the needed body points
		let rightKnee = bodyParts[.rightKnee]!.location
		let rightHip = bodyParts[.rightHip]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location

		// calculate knees angles after standing from squat
		let firstAngle = CGPoint.findAngle(from: rightKnee, to: rightHip)
		let secondAngle = CGPoint.findAngle(from: rightKnee, to: rightAnkle)
		var angleDiffRadians = firstAngle - secondAngle

		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}

		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		if angleDiffDegrees > 150 {
			if currentExerciseStage == .returning {
				repetitionCount += 1
			}
			self.previousExerciseStage = self.currentExerciseStage
			self.currentExerciseStage = .neutral
		}

		// detects when body is in lower position of a squat
		let hipHeight = rightHip.y
		let kneeHeight = rightKnee.y
		if hipHeight < kneeHeight {
			if self.currentExerciseStage == .neutral {
				self.previousExerciseStage = self.currentExerciseStage
				self.currentExerciseStage = .contracting
			}
			countHoldPosition()
		}

	}

	func countHoldPosition() {
		guard holdTimer == nil else { return }
		holdTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
			if self.currentExerciseStage == .contracting {
				self.holdCount += 1
			} else {
				self.holdCount = 0
				timer.invalidate()
				self.holdTimer = nil
			}

			if self.holdCount > 1 {
				self.previousExerciseStage = self.currentExerciseStage
				self.currentExerciseStage = .returning
				self.holdCount = 0
				timer.invalidate()
				self.holdTimer = nil
			}
		}
	}

	private func assertFeetInlineWithFeet(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		guard currentExerciseStage == .neutral else { return }

		let rightShoulder = bodyParts[.rightShoulder]!.location
		let leftShoulder = bodyParts[.leftShoulder]!.location
		let rightFeet = bodyParts[.rightAnkle]!.location
		let leftFeet = bodyParts[.leftAnkle]!.location

		if abs(rightShoulder.x - rightFeet.x) <= 0.11 && abs(leftShoulder.x - leftFeet.x) <= 0.11 {
			postureError.lowerLegs = false
		} else {
			postureError.lowerLegs = true
			speechSynthesizer.speak("Make sure your feet are inline with your shoulders")
		}
	}

	private func assertHorizontallyInlineShoulders(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
		let rightShoulder = bodyParts[.rightShoulder]!.location
		let leftShoulder = bodyParts[.leftShoulder]!.location

		if abs(CGPoint.findGradient(from: leftShoulder, to: rightShoulder)) > 0.05 {
			postureError.shoulders = true
			speechSynthesizer.speak("Make sure your shoulders are straight horizontally")
		} else {
			postureError.shoulders = false
		}
	}

	private func assertThighsWithGroundParalellity(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {

		let rightKnee = bodyParts[.rightKnee]!.location
		let rightHip = bodyParts[.rightHip]!.location
		let rightAnkle = bodyParts[.rightAnkle]!.location

		let firstAngle = CGPoint.findAngle(from: rightKnee, to: rightHip)
		let secondAngle = CGPoint.findAngle(from: rightKnee, to: rightAnkle)
		var angleDiffRadians = firstAngle - secondAngle
		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}

		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		if angleDiffDegrees < 150 && currentExerciseStage == .neutral {
			guard loweringHipTimer == nil else { return }
			loweringHipTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
				self.loweringHipCounter += 1
				if self.loweringHipCounter > 2 {
					self.postureError.upperLegs = true
					self.speechSynthesizer.speak("Make sure your thighs are paralel to the ground while lowering your hips")
					self.loweringHipCounter = 0
				}
			})
		} else {
			loweringHipTimer?.invalidate()
			loweringHipTimer = nil
			loweringHipCounter = 0
			postureError.upperLegs = false
		}
	}
}
