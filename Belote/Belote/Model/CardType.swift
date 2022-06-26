//
//  CardType.swift
//  Belote
//
//  Created by Sitora Guliamova on 19.05.2022.
//

import Foundation

struct CardType: Hashable {
    let cardSuit: CardSuit
    let cardValue: CardValue
    
    init(value: CardValue, suit: CardSuit) {
        self.cardValue = value
        self.cardSuit = suit
    }
    
    init(_ type: CardTypeDTO) {
        switch type.suit {
        case .hearts:
            self.cardSuit = .hearts
        case .diamonds:
            self.cardSuit = .diamonds
        case .spades:
            self.cardSuit = .spades
        case .clubs:
            self.cardSuit = .clubs
        }
        switch type.name {
        case .seven:
            self.cardValue = .seven
        case .eight:
            self.cardValue = .eight
        case .nine:
            self.cardValue = .nine
        case .ten:
            self.cardValue = .ten
        case .jack:
            self.cardValue = .jack
        case .queen:
            self.cardValue = .queen
        case .king:
            self.cardValue = .king
        case .ace:
            self.cardValue = .ace
        }
    }
    
    static func == (lhs: CardType, rhs: CardType) -> Bool {
        return lhs.cardValue == rhs.cardValue && lhs.cardSuit == rhs.cardSuit
    }
    
    static func != (lhs: CardType, rhs: CardType) -> Bool {
        return (lhs.cardValue != rhs.cardValue) || (lhs.cardSuit != rhs.cardSuit)
    }
}

enum CardSuit: String, CaseIterable {
    case hearts = "_of_hearts"
    case diamonds = "_of_diamonds"
    case spades = "_of_spades"
    case clubs = "_of_clubs"
}

enum CardValue: String, CaseIterable {
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    case jack = "jack"
    case queen = "queen"
    case king = "king"
    case ace = "ace"
}

enum CardOrientation {
    case faceUp
    case faceDown
}
