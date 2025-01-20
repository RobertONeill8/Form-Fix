//
//  ExerciseTrackable+FilterBodyParts.swift
//  calistrainer
//
//   on 29/05/22.
//

import Foundation
import Vision

extension ExerciseTrackable {

	func filterBodyParts(
		_ bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint],
		side cameraPerspective: CameraPerspective
	) -> [VNHumanBodyPoseObservation.SymmetricalJointName : VNRecognizedPoint] {

		var filteredBodyParts: [VNHumanBodyPoseObservation.SymmetricalJointName : VNRecognizedPoint] = [:]
		filteredBodyParts[.nose] = bodyParts[.nose]
		filteredBodyParts[.neck] = bodyParts[.neck]
		filteredBodyParts[.root] = bodyParts[.root]

		switch cameraPerspective {
		case .front:
			break
		case .left:
			filteredBodyParts[.shoulder] = bodyParts[.rightShoulder]
			filteredBodyParts[.elbow] = bodyParts[.rightElbow]
			filteredBodyParts[.hip] = bodyParts[.rightHip]
			filteredBodyParts[.wrist] = bodyParts[.rightWrist]
			filteredBodyParts[.knee] = bodyParts[.rightKnee]
			filteredBodyParts[.ankle] = bodyParts[.rightAnkle]
		case .right:
			filteredBodyParts[.shoulder] = bodyParts[.leftShoulder]
			filteredBodyParts[.elbow] = bodyParts[.leftElbow]
			filteredBodyParts[.hip] = bodyParts[.leftHip]
			filteredBodyParts[.wrist] = bodyParts[.leftWrist]
			filteredBodyParts[.knee] = bodyParts[.leftKnee]
			filteredBodyParts[.ankle] = bodyParts[.leftAnkle]
		}

		return filteredBodyParts
	}



}

extension VNHumanBodyPoseObservation {

	enum SymmetricalJointName: String	{
		case nose = "nose"
		case neck = "neck"
		case shoulder = "shoulder"
		case elbow = "elbow"
		case wrist = "wrist"
		case root = "root"
		case hip = "hip"
		case knee = "knee"
		case ankle = "ankle"
	}

}
