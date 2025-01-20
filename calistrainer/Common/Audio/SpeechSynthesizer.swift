//
//  SpeechSynthesizer.swift
//  calistrainer
//
//   on 18/04/22.
//

import Foundation
import AVFoundation

final class SpeechSynthesizer {
	
	private var synthesizer = AVSpeechSynthesizer()

	func speak(_ text: String) {
		guard !synthesizer.isSpeaking else { return }
		let utterance = AVSpeechUtterance(string: text)
		utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
		synthesizer.speak(utterance)
	}

	func stop() {
		synthesizer.stopSpeaking(at: .word)
	}
}
