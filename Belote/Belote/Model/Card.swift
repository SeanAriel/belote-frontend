//
//  Card.swift
//  Belote
//
//  Created by Sitora Guliamova on 19.05.2022.
//

import SpriteKit

final class Card: SKSpriteNode {
    private let backTexture: SKTexture = SKTexture(imageNamed: "card_back")
    private var frontTexture: SKTexture
    
    var cardType: CardType? {
        didSet {
            guard let cardType = cardType else { return }
            self.frontTexture = SKTexture(imageNamed: cardType.cardValue.rawValue + cardType.cardSuit.rawValue)
        }
    }
    
    var isEnabled: Bool
    var orientation: CardOrientation? {
        didSet {
            switch orientation {
            case .faceUp:
                texture = frontTexture
            case .faceDown:
                texture = backTexture
            default:
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(cardType: CardType?) {
        self.cardType = cardType
        guard let cardType = cardType else {
            self.isEnabled = false
            self.frontTexture = SKTexture()
            super.init(texture: backTexture, color: .clear, size: backTexture.size())
            return
        }
        self.isEnabled = true
        self.frontTexture = SKTexture(imageNamed: cardType.cardValue.rawValue + cardType.cardSuit.rawValue)
        super.init(texture: frontTexture, color: .clear, size: frontTexture.size())
    }
}
