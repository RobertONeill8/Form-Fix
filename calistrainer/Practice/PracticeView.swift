//
//  PracticeView.swift
//  calistrainer
//
//   on 18/04/22.
//

import SwiftUI

struct PracticeView: View {
	@Environment(\.presentationMode) var presentationMode
	
	let exercise: Exercise
	@StateObject var viewModel: PracticeViewModel
	@State private var animationAmount = 1.0
	@State private var isShowingMenu = false
	
	let audioManager = AudioManager.shared
	
	var body: some View {
		
		ZStack {
			Group {
				Color("PrimaryGray").ignoresSafeArea()
				VStack {
					HStack {
						if viewModel.bodyInFrame {
							HStack {
								Text("Reps: ")
									.font(.title)
									.fontWeight(.semibold)
								Text(String(viewModel.exerciseTrackable.repetitionCount))
									.font(.title)
									.fontWeight(.bold)
							}
							.foregroundColor(Color("PrimaryLime"))
						} else {
							Text("Make sure your whole body fits the frame")
								.font(.title2)
								.fontWeight(.semibold)
								.foregroundColor(Color("PrimaryLime"))
								.multilineTextAlignment(.leading)
								.fixedSize(horizontal: false, vertical: true)
						}
						Spacer()
						Button {
							withAnimation {
								isShowingMenu.toggle()
							}
						} label: {
							HStack {
								Text("Finish")
									.fontWeight(.semibold)
								Image(systemName: "checkmark")
							}
							.foregroundColor(Color("PrimaryGray"))
							.padding(.horizontal)
							.padding(.vertical, 10)
							.background(
								RoundedRectangle(cornerRadius: 4)
									.fill(Color("PrimaryLime"))
							)
						}
						
					}
					.padding(.horizontal)
					.padding(.vertical, 10)
					ZStack {
						VStack {
							Spacer()
							ProgressView(
								value: viewModel.bodyInFrame ? viewModel.progressValue : viewModel.bodyInFrameCount,
								total: viewModel.bodyInFrame ? 2.0 : 3.0
							)
							.progressViewStyle(PracticeProgressViewStyle())
							.onChange(of: viewModel.bodyInFrame) { _ in
								audioManager.playSound(sound: "start", type: "wav")
							}
							.onChange(of: viewModel.bodyInFrameCount) { count in
								if (1..<4).contains(count) {
									audioManager.playSound(sound: "countdown", type: "wav")
								}
							}
						}.ignoresSafeArea()
						
						GeometryReader { geo in
							CameraViewWrapper(viewModel: viewModel)
								.clipShape(RoundedRectangle(cornerRadius: 20))
							StickFigureView(viewModel: viewModel, size: geo.size)
						}.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920/1080, alignment: .bottom)
						
						VStack {
							Spacer()
							if viewModel.bodyInFrame {
								PracticeInstructionTextView(
									exercise: exercise,
									stage: viewModel.exerciseTrackable.currentExerciseStage,
									previousStage: viewModel.exerciseTrackable.previousExerciseStage
								)
							}
						}.padding(.bottom, 30)
					}
				}
			}
			.blur(radius: isShowingMenu ? 30 : 0)
			if isShowingMenu {
				AlertView(
					title: "Are you done?",
					leftButtonLabel: "Continue exercise",
					rightButtonLabel: "Finish exercise"
				) {
					withAnimation {
						isShowingMenu.toggle()
					}
				} rightButtonAction: {
					viewModel.savePracticeData(exercise: exercise)
					self.presentationMode.wrappedValue.dismiss()
				}
			}
		}
		
	}
}
