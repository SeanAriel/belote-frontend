//
//  BeloteWebTransformer.swift
//  Belote
//
//  Created by Sitora Guliamova on 26.05.2022.
//

import Foundation

final class BeloteWebTransformer {
    func transform(_ webModel: BeloteWebResponse) -> Belote {
        Belote(actions: actionsTransform(actions: webModel.actions),
               agreedUponContract: actionNameTransform(name: webModel.agreed_upon_contract),
               aiActions: webModel.ai_actions,
               deal: webModel.deal.map { dealTransform(deal: $0) },
               legalActions: webModel.legal_actions,
               playerTurn: webModel.player_turn,
               wholeDeal: webModel.whole_deal.map { dealTransform(deal: $0) })
    }

    func transform(_ webError: BeloteWebServiceError) -> BeloteServiceError {
        switch webError {
        case .commonError: return .commonError
        }
    }
    
    private func actionsTransform(actions: [[String]]) -> [Int: ActionType] {
        var dictActions = [Int: ActionType]()
        for action in actions {
            guard let stringIndex = action.last,
                  let index = Int(stringIndex),
                  let string = action.first,
                  let stringData = string.data(using: .utf8) else { return dictActions }
            
            if let data = try? JSONDecoder().decode(CardTypeDTO.self, from: stringData) {
                dictActions[index] = .game(cardType: CardType(data))
            } else {
                dictActions[index] = .launch(name: actionNameTransform(name: string))
            }
        }
        return dictActions
    }
    
    private func dealTransform(deal: String) -> CardType? {
        guard let stringData = deal.data(using: .utf8),
              let data = try? JSONDecoder().decode(CardTypeDTO.self, from: stringData) else { return nil }
        
        return CardType(data)
    }
    
    private func actionNameTransform(name: String) -> ActionName {
        switch name {
        case ActionName.clubs.rawValue:
            return .clubs
        case ActionName.diamonds.rawValue:
            return .diamonds
        case ActionName.hearts.rawValue:
            return .hearts
        case ActionName.spades.rawValue:
            return .spades
        case ActionName.sa.rawValue:
            return .sa
        case ActionName.ta.rawValue:
            return .ta
        case ActionName.pass.rawValue:
            return .pass
        default:
            return .pass
        }
    }
}

