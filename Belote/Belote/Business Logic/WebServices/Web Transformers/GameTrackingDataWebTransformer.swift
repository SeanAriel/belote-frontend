//
//  GameTrackingDataWebTransformer.swift
//  Belote
//
//  Created by Sitora Guliamova on 29.05.2022.
//

import Foundation

final class GameTrackingDataWebTransformer {
    func transform(_ webModel: GameTrackingDataWebResponse) -> GameTrackingData {
        GameTrackingData(gameNumber: webModel.game_number,
                         gameState: webModel.game_state,
                         scorePerspective: webModel.score_p1_perspective,
                         sessionCode: webModel.session_code,
                         startingPlayer: webModel.starting_player)
    }

    func transform(_ webError: BeloteWebServiceError) -> BeloteServiceError {
        switch webError {
        case .commonError: return .commonError
        }
    }
}
