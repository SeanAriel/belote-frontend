//
//  BeloteWebResponse.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

struct BeloteWebResponse: Decodable {
    let actions: [[String]]
    let agreed_upon_contract: String
    let ai_actions: [Int]
    let deal: [String]
    let legal_actions: [Int]
    let player_turn: Int
    let whole_deal: [String]
}
