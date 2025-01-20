//
//  PushupTrackable.swift
//  calistrainer
//
//   on 26/05/22.
//

import Foundation
import Vision
import Combine

final class PushupTrackable: ExerciseTrackable {

	var repetitionCount: Int = 0
	var currentExerciseStage: ExerciseStage = .neutral
	var previousExerciseStage: ExerciseStage?
	var postureError = PostureError()
	var cameraPerspective: CameraPerspective?

	private var holdTimer: Timer?
	private var holdCount = 0

	private var loweringChestTimer: Timer?
	private var loweringChestCounter = 0

	let speechSynthesizer = SpeechSynthesizer()

	func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {

		let filteredBodyParts = filterBodyParts(bodyParts, side: cameraPerspective!)

		assertStraightBody(bodyParts: filteredBodyParts)
		assertRangeOfMotion(bodyParts: filteredBodyParts)

		// declare the needed body points
		let neck = filteredBodyParts[.neck]!.location
		let shoulder = filteredBodyParts[.shoulder]!.location
		let elbow = filteredBodyParts[.elbow]!.location
		let wrist = filteredBodyParts[.wrist]!.location

		let firstAngle = CGPoint.findAngle(from: shoulder, to: elbow)
		let secondAngle = CGPoint.findAngle(from: elbow, to: wrist)
		var angleDiffRadians = firstAngle - secondAngle

		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}

		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		if elbowReturnedStraight(angle: angleDiffDegrees) {
			if currentExerciseStage == .returning {
				repetitionCount += 1
			}
			self.previousExerciseStage = self.currentExerciseStage
			self.currentExerciseStage = .neutral
		}

		// detects when body is in lower position of a pushup
		let neckToWristDistance = CGPoint.findDistance(from: neck, to: wrist)
		if neckToWristDistance < 0.2 {
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

	private func assertStraightBody(bodyParts: [VNHumanBodyPoseObservation.SymmetricalJointName : VNRecognizedPoint]) {
		let neck = bodyParts[.neck]!.location
		let hips = bodyParts[.hip]!.location
		let knee = bodyParts[.knee]!.location

		let firstAngle = CGPoint.findAngle(from: neck, to: hips)
		let secondAngle = CGPoint.findAngle(from: hips, to: knee)
		var angleDiffRadians = firstAngle - secondAngle

		while angleDiffRadians < 0 {
			angleDiffRadians += CGFloat(2 * Double.pi)
		}

		let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
		print("angle \(angleDiffDegrees)")
		if bodyIsNotStraight(angle: angleDiffDegrees) {
			postureError.spine = true
			postureError.upperLegs = true
			speechSynthesizer.speak("Straighten your back and hips")
		} else {
			postureError.spine = false
			postureError.upperLegs = false
		}
	}

	private func assertRangeOfMotion(bodyParts: [VNHumanBodyPoseObservation.SymmetricalJointName : VNRecognizedPoint]) {
		if currentExerciseStage == .neutral {
			guard loweringChestTimer == nil else { return }
			loweringChestTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
				self.loweringChestCounter += 1
				if self.loweringChestCounter > 2 {
					self.postureError.arms = true
					self.postureError.shoulders = true
					self.speechSynthesizer.speak("Lower your chest until it barely touches the ground")
					self.loweringChestCounter = 0
				}
			})
		} else {
			loweringChestTimer?.invalidate()
			loweringChestTimer = nil
			loweringChestCounter = 0
			postureError.arms = false
			postureError.shoulders = false
		}
	}

	private func elbowReturnedStraight(angle: Int) -> Bool {
		switch cameraPerspective {
		case .right: return angle < 100
		case .left: return angle > 300
		default: return false
		}
	}

	private func bodyIsNotStraight(angle: Int) -> Bool {
		switch cameraPerspective {
		case .right: return (30..<340).contains(angle)
		case .left: return (30..<340).contains(angle)
		default: return false
		}
	}

}
