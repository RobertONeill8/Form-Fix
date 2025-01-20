//
//  CameraView.swift
//  calistrainer
//
//   on 18/04/22.
//

import AVFoundation
import UIKit

final class CameraView: UIView {

	override class var layerClass: AnyClass {
		AVCaptureVideoPreviewLayer.self
	}

	var previewLayer: AVCaptureVideoPreviewLayer {
		layer as! AVCaptureVideoPreviewLayer
	}
}
