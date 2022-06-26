//
//  CardTypeDTO.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

struct CardTypeDTO: Codable {
    let suit: CardSuitDTO
    let name: CardValueDTO
}

enum CardSuitDTO: String, Codable {
    case hearts = "hearts"
    case diamonds = "diamonds"
    case spades = "spades"
    case clubs = "clubs"
}

enum CardValueDTO: String, Codable {
    case seven = "seven"
    case eight = "eight"
    case nine = "nine"
    case ten = "ten"
    case jack = "jack"
    case queen = "queen"
    case king = "king"
    case ace
}
