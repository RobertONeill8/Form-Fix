//  BentOverRowsTrackable.swift
//  calistrainer
//
//

import Foundation
import Combine
import Vision

final class BentOverRowsTrackable: ExerciseTrackable {

    var repetitionCount = 0
    var currentExerciseStage: ExerciseStage = .neutral
    var previousExerciseStage: ExerciseStage?
    var postureError = PostureError()
    var cameraPerspective: CameraPerspective?

    private var holdTimer: Timer?
    private var holdCount = 0

    let speechSynthesizer = SpeechSynthesizer()

    func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {

        self.assertNeutralSpine(bodyParts: bodyParts)
        self.assertShoulderBladeRetraction(bodyParts: bodyParts)
        self.assertBentOverPosition(bodyParts: bodyParts)

        // declare the needed body points
        let rightElbow = bodyParts[.rightElbow]!.location
        let rightShoulder = bodyParts[.rightShoulder]!.location
        let rightWrist = bodyParts[.rightWrist]!.location

        // calculate arm angles after pulling up during the row
        let upperArmAngle = CGPoint.findAngle(from: rightElbow, to: rightShoulder)
        let lowerArmAngle = CGPoint.findAngle(from: rightElbow, to: rightWrist)
        var angleDiffRadians = upperArmAngle - lowerArmAngle

        while angleDiffRadians < 0 {
            angleDiffRadians += CGFloat(2 * Double.pi)
        }

        let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
        
        // Detects when the arm is fully extended (lowered position)
        if angleDiffDegrees < 30 {
            if currentExerciseStage == .contracting {
                repetitionCount += 1
            }
            self.previousExerciseStage = self.currentExerciseStage
            self.currentExerciseStage = .returning
        }

        // Detects when the arm is bent (raising phase of the row)
        let elbowHeight = rightElbow.y
        let shoulderHeight = rightShoulder.y
        if elbowHeight > shoulderHeight {
            if self.currentExerciseStage == .neutral || self.currentExerciseStage == .returning {
                self.previousExerciseStage = self.currentExerciseStage
                self.currentExerciseStage = .contracting
                speechSynthesizer.speak("Raise")
            }
            countHoldPosition()
        } else if angleDiffDegrees > 90 && self.currentExerciseStage == .contracting {
            self.previousExerciseStage = self.currentExerciseStage
            self.currentExerciseStage = .neutral
            speechSynthesizer.speak("Lower")
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

    private func assertNeutralSpine(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        guard currentExerciseStage == .neutral else { return }

        let rightShoulder = bodyParts[.rightShoulder]!.location
        let rightHip = bodyParts[.rightHip]!.location
        let rightAnkle = bodyParts[.rightAnkle]!.location

        let spineAngle = CGPoint.findAngle(from: rightShoulder, to: rightHip)
        let legAngle = CGPoint.findAngle(from: rightHip, to: rightAnkle)
        let angleDiff = abs(spineAngle - legAngle)

        if angleDiff > CGFloat.pi / 6 {
            postureError.spine = true
            speechSynthesizer.speak("Keep your spine neutral and avoid rounding your back")
        } else {
            postureError.spine = false
        }
    }

    private func assertShoulderBladeRetraction(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        let rightShoulder = bodyParts[.rightShoulder]!.location
        let leftShoulder = bodyParts[.leftShoulder]!.location

        if abs(CGPoint.findGradient(from: leftShoulder, to: rightShoulder)) > 0.05 {
            postureError.shoulders = true
            speechSynthesizer.speak("Make sure to retract your shoulder blades during the pull")
        } else {
            postureError.shoulders = false
        }
    }

    private func assertBentOverPosition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        let rightHip = bodyParts[.rightHip]!.location
        let rightShoulder = bodyParts[.rightShoulder]!.location
        let rightKnee = bodyParts[.rightKnee]!.location

        let torsoAngle = CGPoint.findAngle(from: rightShoulder, to: rightHip)
        let thighAngle = CGPoint.findAngle(from: rightHip, to: rightKnee)
        let angleDiff = abs(torsoAngle - thighAngle)

        if angleDiff < CGFloat.pi / 3 {
            postureError.bentOverPosition = true
            speechSynthesizer.speak("Make sure your torso is properly bent over for the row")
        } else {
            postureError.bentOverPosition = false
        }
    }
}

