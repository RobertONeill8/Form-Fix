//
//  MainTabView.swift
//  calistrainer
//
//   on 15/03/22.
//

import SwiftUI

struct MainTabView: View {
	var body: some View {
		NavigationView {
			TabView {
				HomeView()
					.tabItem {
						Label("Practice", systemImage: "figure.walk")
					}
					.navigationTitle("")
					.navigationBarHidden(true)
				ExerciseLogsView()
					.tabItem {
						Label("Exercise Log", systemImage: "heart.text.square.fill")
					}
					.navigationTitle("")
					.navigationBarHidden(true)
			}
		}
	}
}

struct MainTabView_Previews: PreviewProvider {
	static var previews: some View {
		MainTabView()
			.preferredColorScheme(.dark)
	}
}
