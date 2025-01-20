//
//  AudioManager.swift
//  calistrainer
//
//   on 18/04/22.
//

import Foundation
import AVFoundation

final class AudioManager {

	static let shared = AudioManager()

	var audioPlayer = AVAudioPlayer()

	func playSound(sound: String, type: String) {
		if let path = Bundle.main.path(forResource: sound, ofType: type) {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
				audioPlayer.play()
			} catch {
				print("Can't play the sound file")
			}
		}
	}

	func stopSound(sound: String, type: String) {
		if let path = Bundle.main.path(forResource: sound, ofType: type) {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
				audioPlayer.stop()
			} catch {
				print("Can't stop the sound file")
			}
		}
	}
}
