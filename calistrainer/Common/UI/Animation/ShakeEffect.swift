//
//  ShakeEffect.swift
//  calistrainer
//
//   on 22/04/22.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {

	var animatableData: CGFloat

	func modifier(_ x: CGFloat) -> CGFloat {
		10 * sin(x * .pi * 2)
	}

	func effectValue(size: CGSize) -> ProjectionTransform {
		ProjectionTransform(CGAffineTransform(translationX: 0, y: 10 + modifier(animatableData)))
	}

}
