//
//  ExerciseTrackable.swift
//  calistrainer
//
//   on 18/04/22.
//

import Foundation
import Vision
import Combine

protocol ExerciseTrackable {
	var repetitionCount: Int { get }
	var currentExerciseStage: ExerciseStage { get }
	var previousExerciseStage: ExerciseStage? { get }
	var postureError: PostureError { get }
	var cameraPerspective: CameraPerspective? { get set }
	func countRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint])
}
