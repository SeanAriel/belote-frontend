//
//  GameTrackingDataWebResponse.swift
//  Belote
//
//  Created by Sitora Guliamova on 29.05.2022.
//

import Foundation

struct GameTrackingDataWebResponse: Decodable {
    let game_number: Int
    let game_state: String
    let score_p1_perspective: Int
    let session_code: String
    let starting_player: Int
}
