//
//  ExerciseStage.swift
//  calistrainer
//
//   on 18/04/22.
//

import Foundation
import Vision

enum ExerciseStage {
    case neutral
    case contracting
    case returning
}

extension ExerciseStage {
    static func promptString(exercise: Exercise, stage: ExerciseStage) -> String {
        switch stage {
        case .neutral:
            switch exercise {
            case .squat: fallthrough
            case .pushup: fallthrough
            case .bentOverRow: return "LOWER"
            }
        case .contracting:
            switch exercise {
            case .squat: fallthrough
            case .pushup: fallthrough
            case .bentOverRow: return "HOLD"
            }
        case .returning:
            switch exercise {
            case .squat: return "RETURN"
            case .pushup: return "RAISE"
            case .bentOverRow: return "PULL"
            }
        }
    }
}

