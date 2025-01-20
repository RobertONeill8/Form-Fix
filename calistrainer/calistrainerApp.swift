//
//  calistrainerApp.swift
//  calistrainer
//
//   on 14/03/22.
//

import SwiftUI

@main
struct calistrainerApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
				.preferredColorScheme(.dark)
        }
    }
}
