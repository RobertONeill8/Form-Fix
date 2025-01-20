//
//  PracticePreparationView.swift
//  calistrainer
//
//   on 29/05/22.
//
import SwiftUI

struct PracticePreparationView: View {

	let exercise: Exercise
	var isAbleToChoosePerspective: Bool
	@Binding var isShowingPracticePreparationView: Bool

	@State var cameraPerspective: CameraPerspective
	private let cameraOptions: [CameraPerspective] = [.left, .right]

	@State var showPracticeView = false

	init(
		exercise: Exercise,
		isAbleToChoosePerspective: Bool = false,
		isShowingPracticePreparationView: Binding<Bool>
	) {
		self.exercise = exercise
		self.isAbleToChoosePerspective = isAbleToChoosePerspective
		_isShowingPracticePreparationView = isShowingPracticePreparationView
		_cameraPerspective = State(initialValue: isAbleToChoosePerspective ? .left : .front)
		UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("PrimaryGray"))], for: .selected)
		UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.accentColor)], for: .normal)
	}

	var body: some View {
		ZStack {
			Color("PrimaryGray").ignoresSafeArea()
			VStack(spacing: 10) {

				Spacer()

				VStack(alignment: .leading) {
					Text("Before practicing, make sure of the followings:")
						.font(.subheadline)
						.padding(.bottom, 5)
					HStack(alignment: .top) {
						Text("⚠︎")
						Text("Your iPhone can be placed on the floor vertically")
					}
					.font(.headline)
					.padding(.bottom, 2)
					HStack(alignment: .top) {
						Text("⚠︎")
						Text("You have clear surroundings")
					}
					.font(.headline)
					.padding(.bottom, 2)
					if isAbleToChoosePerspective {
						HStack(alignment: .top) {
							Text("⚠︎")
							Text("Your iPhone orientation is in the same direction as your body")
						}
						.font(.headline)
					}
				}
				.foregroundColor(Color("PrimaryGray"))
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 10)
						.foregroundColor(.yellow)
				)
				.padding()

				if isAbleToChoosePerspective {

					VStack(spacing: 25) {
						Text("Which side do you want to face when practicing?")
							.fontWeight(.semibold)
							.multilineTextAlignment(.center)
						Picker("test", selection: $cameraPerspective) {
							ForEach(cameraOptions, id:\.self) { cameraOption in
								Text(cameraOption.rawValue)
							}
						}
						.pickerStyle(.segmented)
					}
					.frame(maxWidth: 250)
					.padding()
				}

				switch cameraPerspective {
				case .front:
					Image("FrontCamera")
						.resizable()
						.scaledToFit()
				case .right:
					Image("RightCamera")
						.resizable()
						.scaledToFit()
						.padding()
				case .left:
					Image("LeftCamera")
						.resizable()
						.scaledToFit()
						.padding()
				}


				Spacer()

				PrimaryButton(label: "Start!", fullWidth: true) {
					showPracticeView = true
				}
				.padding([.horizontal, .bottom])
				.fullScreenCover(isPresented: $showPracticeView) {
					PracticeView(
						exercise: exercise,
						viewModel: PracticeViewModel(exercise: exercise, cameraPerspective: cameraPerspective)
					)
				}
			}
		}
		.navigationTitle(exercise.rawValue)
		.navigationBarTitleDisplayMode(.large)
		.onChange(of: showPracticeView) { newValue in
			if newValue == false {
				isShowingPracticePreparationView = false
			}
		}
	}
}

struct PracticePreparationView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			PracticePreparationView(exercise: .squat, isAbleToChoosePerspective: true, isShowingPracticePreparationView: .constant(true))
		}.preferredColorScheme(.dark)
	}
}
