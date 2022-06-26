//
//  Belote.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

struct Belote {
    let actions: [Int: ActionType]
    let agreedUponContract: ActionName
    let aiActions: [Int]
    let deal: [CardType?]
    let legalActions: [Int]
    let playerTurn: Int
    let wholeDeal: [CardType?]
}

struct Action {
    let actionType: ActionType
    let indexAction: Int
}

enum ActionType: Equatable {
    case launch(name: ActionName)
    case game(cardType: CardType)
    
    static func == (lhs: ActionType, rhs: ActionType) -> Bool {
        switch lhs {
        case .launch(let lhsName):
            switch rhs {
            case .launch(let rhsName):
                return lhsName == rhsName
            case .game:
                return false
            }
        case .game(let lhsCardType):
            switch rhs {
            case .launch:
                return false
            case .game(let rhsCardType):
                return lhsCardType == rhsCardType
            }
        }
    }
}

enum ActionName: String {
    case clubs = "clubs"
    case diamonds = "diamonds"
    case hearts = "hearts"
    case spades = "spades"
    case sa = "sans_atouts"
    case ta = "tout_atouts"
    case pass = "final_pass"
}
