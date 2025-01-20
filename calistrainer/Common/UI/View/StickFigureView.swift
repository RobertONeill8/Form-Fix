//
//  StickFigureView.swift
//  calistrainer
//
//   on 18/04/22.
//

import SwiftUI

struct StickFigureView: View {
	
	@ObservedObject var viewModel: PracticeViewModel
	var size: CGSize
	private let defaultColor: Color = Color("PrimaryLime")
	private let errorColor: Color = .red
	
	var body: some View {
		if viewModel.bodyParts.isEmpty == false {
			ZStack {
				Group {
					if viewModel.cameraPerspective == .left || viewModel.cameraPerspective == .front {
						// Right hip
						Stick(
							points: [
								viewModel.bodyParts[.root]!.location,
								viewModel.bodyParts[.rightHip]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.upperLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Right thigh
						Stick(
							points: [
								viewModel.bodyParts[.rightKnee]!.location,
								viewModel.bodyParts[.rightHip]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.lowerLegs||viewModel.exerciseTrackable.postureError.upperLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Right calf
						Stick(
							points: [
								viewModel.bodyParts[.rightKnee]!.location,
								viewModel.bodyParts[.rightAnkle]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.lowerLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)


						// Right arm
						Stick(
							points: [
								viewModel.bodyParts[.rightWrist]!.location,
								viewModel.bodyParts[.rightElbow]!.location,
								viewModel.bodyParts[.rightShoulder]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.arms
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Right shoulder
						Stick(
							points: [
								viewModel.bodyParts[.rightShoulder]!.location,
								viewModel.bodyParts[.neck]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.shoulders
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)
					}
				}
				Group {
					if viewModel.cameraPerspective == .right || viewModel.cameraPerspective == .front {
						// Left hip
						Stick(
							points: [
								viewModel.bodyParts[.root]!.location,
								viewModel.bodyParts[.leftHip]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.upperLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Left thigh
						Stick(
							points: [
								viewModel.bodyParts[.leftHip]!.location,
								viewModel.bodyParts[.leftKnee]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.lowerLegs || viewModel.exerciseTrackable.postureError.upperLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Left calf
						Stick(
							points: [
								viewModel.bodyParts[.leftKnee]!.location,
								viewModel.bodyParts[.leftAnkle]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.lowerLegs
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Left arm
						Stick(
							points: [
								viewModel.bodyParts[.leftWrist]!.location,
								viewModel.bodyParts[.leftElbow]!.location,
								viewModel.bodyParts[.leftShoulder]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.arms
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)

						// Left shoulder
						Stick(
							points: [
								viewModel.bodyParts[.leftShoulder]!.location,
								viewModel.bodyParts[.neck]!.location
							],
							size: size
						)
						.stroke(lineWidth: 5.0)
						.fill(
							viewModel.exerciseTrackable.postureError.shoulders
							? errorColor
							: defaultColor
						)
						.shadow(color: .black, radius: 3, x: 0, y: 0)
					}
				}
				// Root to neck
				Stick(
					points: [
						viewModel.bodyParts[.root]!.location,
						viewModel.bodyParts[.neck]!.location
					],
					size: size
				)
				.stroke(lineWidth: 5.0)
				.fill(
					viewModel.exerciseTrackable.postureError.spine
					? errorColor
					: defaultColor
				)
				.shadow(color: .black, radius: 3, x: 0, y: 0)
			}
		}
	}
}
