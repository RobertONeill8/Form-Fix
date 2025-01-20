//
//  OnboardingView.swift
//  calistrainer
//
//   on 06/06/22.
//

import SwiftUI

struct OnboardingView: View {

	@Binding var isShowingOnboarding: Bool
	@State private var username: String = ""

	private let userDefaults = UserDefaults.standard

	var body: some View {
		ZStack {
			Color("PrimaryGray").ignoresSafeArea()
			VStack(spacing: 30) {
				Spacer()
				Image("Calistrainer")
					.resizable()
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.aspectRatio(contentMode: .fit)
					.frame(width: 200)
				Spacer()
				VStack(spacing: 50) {
					Group {
						Text("Welcome to ")
							.font(.title)
							.fontWeight(.semibold)
						+
						Text("Calistrainer")
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(.accentColor)
						Text("Let's get started!")
							.font(.title2)
							.fontWeight(.semibold)
					}
					TextField("Enter your name", text: $username)
						.font(.title2.weight(.semibold))
						.disableAutocorrection(true)
						.multilineTextAlignment(.center)
						.foregroundColor(.accentColor)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color("SecondaryGray"))
						)
				}
				Spacer()
				PrimaryButton(label: "Start Now", fullWidth: true, disabled: username.isEmpty) {
					userDefaults.set(username, forKey: "username")
					isShowingOnboarding = false
				}

			}.padding()
		}
		.onAppear {
			username = userDefaults.string(forKey: "username") ?? ""
		}
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView(isShowingOnboarding: .constant(true))
			.preferredColorScheme(.dark)
	}
}
