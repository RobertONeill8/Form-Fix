//
//  CameraViewWrapper.swift
//  calistrainer
//
//   on 18/04/22.
//

import SwiftUI
import AVFoundation
import Vision

struct CameraViewWrapper: UIViewControllerRepresentable {

	var viewModel: PracticeViewModel

	func makeUIViewController(context: Context) -> some UIViewController {
		let cvc = CameraViewController()
		cvc.delegate = viewModel
		return cvc
	}

	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
