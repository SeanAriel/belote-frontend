//
//  GameScene.swift
//  Belote
//
//  Created by Sitora Guliamova on 18.05.2022.
//

import SpriteKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func didTapCard(_ scene: SKScene, card: CardType) -> Bool
    func didMoveCard(who: Who)
    func gameOver()
}

enum CardLevel: CGFloat {
    case moving = 1000
    case enlarged = 200
    case faceUp = 20
    case faceDown = 10
}

enum Who {
    case user
    case pc
}

final class GameScene: SKScene {
    private var userCardsInHand: [CardType?]?
    private var userCardsFaceUp: [CardType?]?
    private var userCardsFaceDown: [CardType?]?
    private var pcCardsFaceDown: [CardType?]?
    private var pcCardsFaceUp: [CardType?]?
    private var pcCardsInHand: [CardType?]?
    
    private var aiCards = [CardType: Card]()
    
    private var userCards = [CardType: Card]() {
        didSet {
            if userCards.isEmpty {
                guard let cardType = aiCards.first?.key else { return }
                moveToCard(action: .game(cardType: cardType)) { }
            }
        }
    }
    
    private var cardsToCenter: [Card?] = [] {
        didSet {
            if cardsToCenter.count == 2 {
                cardsToCenter.forEach {
                    guard let card = $0 else { return }
                    card.orientation = .faceDown
                    moved(shape: card, point: layoutCards.pointScore.user) { }
                }
                checkEndGame()
                cardsToCenter.removeAll()
            }
        }
    }
    
    var deal: [CardType?]? {
        didSet {
            guard let deal = deal else { return }
            self.userCardsInHand = Array(deal[0...7])
            self.userCardsFaceUp = Array(deal[8...11])
            self.userCardsFaceDown = Array(deal[12...15])
            self.pcCardsFaceDown = Array(deal[16...19])
            self.pcCardsFaceUp = Array(deal[20...23])
            self.pcCardsInHand = Array(deal[24...31])
        }
    }
    
    weak var gameDelegate: GameSceneDelegate?
    
    override func didMove(to view: SKView) {
        guard let userCardsInHand = userCardsInHand,
              let userCardsFaceUp = userCardsFaceUp,
              let userCardsFaceDown = userCardsFaceDown,
              let pcCardsFaceDown = pcCardsFaceDown,
              let pcCardsFaceUp = pcCardsFaceUp,
              let pcCardsInHand = pcCardsInHand else { return }
        
        layOutAllCards(userCardsInHand: userCardsInHand,
                       userCardsFaceUp: userCardsFaceUp,
                       userCardsFaceDown: userCardsFaceDown,
                       pcCardsFaceDown: pcCardsFaceDown,
                       pcCardsFaceUp: pcCardsFaceUp,
                       pcCardsInHand: pcCardsInHand)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let card = atPoint(location) as? Card, card.isEnabled {
                guard let cardType = card.cardType else { return }
                let position = card.position
                if gameDelegate?.didTapCard(self, card: cardType) == true {
                    self.moved(shape: card, point: layoutCards.pointUser) {
                        self.cardsToCenter.append(card)
                        self.userCards[cardType] = nil
                        self.gameDelegate?.didMoveCard(who: .user)
                        if let newCard = self.atPoint(position) as? Card, card.cardType != newCard.cardType {
                            newCard.orientation = .faceUp
                        }
                    }
                } else {
                    card.run(CustomAction.getWiggleAction(angle: 0.15, duration: 0.1, count: 2))
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {

        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {

        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func moveToCard(action: ActionType?, complition: @escaping () -> ()) {
        guard let action = action else { return }

        switch action {
        case .game(cardType: let card):
            guard let result = aiCards[card] else { return }
            result.orientation = .faceUp
            let location = result.position
            moved(shape: result, point: layoutCards.pointAi) {
                complition()
                self.cardsToCenter.append(result)
                self.gameDelegate?.didMoveCard(who: .pc)
                if let newCard = self.atPoint(location) as? Card, card != newCard.cardType {
                    newCard.orientation = .faceUp
                }
            }
        default:
            break
        }
    }
    
    func restartGame() {
        guard let userCardsInHand = userCardsInHand,
              let userCardsFaceUp = userCardsFaceUp,
              let userCardsFaceDown = userCardsFaceDown,
              let pcCardsFaceDown = pcCardsFaceDown,
              let pcCardsFaceUp = pcCardsFaceUp,
              let pcCardsInHand = pcCardsInHand else { return }
        
        layOutAllCards(userCardsInHand: userCardsInHand,
                       userCardsFaceUp: userCardsFaceUp,
                       userCardsFaceDown: userCardsFaceDown,
                       pcCardsFaceDown: pcCardsFaceDown,
                       pcCardsFaceUp: pcCardsFaceUp,
                       pcCardsInHand: pcCardsInHand)
    }
    
    private func checkEndGame() {
        if self.aiCards.isEmpty == true && self.userCards.isEmpty == true {
            self.gameDelegate?.gameOver()
        }
    }
    
    private func layOutAllCards(userCardsInHand: [CardType?],
                                userCardsFaceUp: [CardType?],
                                userCardsFaceDown: [CardType?],
                                pcCardsFaceDown: [CardType?],
                                pcCardsFaceUp: [CardType?],
                                pcCardsInHand: [CardType?]) {
        
        var zPosition = CardLevel.faceUp.rawValue
        layOutCards(layoutSize: layoutCards.inHand.user.rect, cards: userCardsInHand).forEach {
            guard let cardType = $0.cardType else { return }
            userCards[cardType] = $0
            $0.zPosition = zPosition
            zPosition += 1
            addChild($0)
        }
        
        zPosition = CardLevel.faceUp.rawValue
        layOutCards(layoutSize: layoutCards.inField.user.faceUp, cards: userCardsFaceUp).forEach {
            guard let cardType = $0.cardType else { return }
            userCards[cardType] = $0
            $0.zPosition = zPosition
            zPosition += 1
            addChild($0)
        }
        
        zPosition = CardLevel.faceDown.rawValue
        layOutCards(layoutSize: layoutCards.inField.user.faceDown, cards: userCardsFaceDown).forEach {
            guard let cardType = $0.cardType else { return }
            userCards[cardType] = $0
            $0.zPosition = zPosition
            zPosition += 1
            $0.orientation = .faceDown
            addChild($0)
        }
        
        zPosition = CardLevel.faceDown.rawValue
        layOutCards(layoutSize: layoutCards.inField.ai.faceDown, cards: pcCardsFaceDown).forEach {
            guard let cardType = $0.cardType else { return }
            aiCards[cardType] = $0
            $0.zPosition = zPosition
            zPosition += 1
            $0.orientation = .faceDown
            addChild($0)
        }
        
        zPosition = CardLevel.faceUp.rawValue
        layOutCards(layoutSize: layoutCards.inField.ai.faceUp, cards: pcCardsFaceUp).forEach {
            guard let cardType = $0.cardType else { return }
            aiCards[cardType] = $0
            $0.isEnabled = false
            $0.zPosition = zPosition
            zPosition += 1
            addChild($0)
        }
        
        zPosition = CardLevel.faceUp.rawValue
        layOutCards(layoutSize: layoutCards.inHand.ai.rect, cards: pcCardsInHand).forEach {
            guard let cardType = $0.cardType else { return }
            aiCards[cardType] = $0
            $0.zPosition = zPosition
            zPosition += 1
            $0.orientation = .faceDown
            addChild($0)
        }
    }
    
    private func layOutCards(layoutSize: CGRect, cards: [CardType?]) -> [Card] {
        let range = 0..<cards.count
        let cardSize = layoutCards.cardSize
        let spasing = (layoutSize.width - cardSize.width * cards.count.cgFloat) / (cards.count - 1).cgFloat
        let cardsNode: [Card] = range.map {
            let card = Card(cardType: cards[$0])
            card.size = cardSize
            card.position = CGPoint(x: layoutSize.minX + cardSize.width / 2 + CGFloat($0) * (spasing + cardSize.width),
                                    y: layoutSize.origin.y)

            return card
        }
        return cardsNode
    }
    
    private func moved(shape: SKNode, point: CGPoint, complition: @escaping () -> ()) {
        guard let shape = shape as? Card, let cardType = shape.cardType else { return }
        aiCards[cardType] = nil
        userCards[cardType] = nil
        var zPosition = CardLevel.moving.rawValue
        if let card = atPoint(point) as? Card {
            zPosition = card.zPosition + 5
        }

        let moveAction = CustomAction.getMoveAction(startPoint: shape.position,
                                                    endPoint: point,
                                                    speedRange: 600...700,
                                                    varyingBy: 500)
        
        shape.isEnabled = false
        shape.zPosition = zPosition
        shape.run(SKAction.scale(to: 1.3, duration: 0.15)) {
            shape.run(moveAction) {
                shape.run(SKAction.scale(to: 1.0, duration: 0.15))
                shape.removeFromParent()
                self.addChild(shape)
                complition()
            }
        }
    }
}

extension GameScene {
    private var layoutCards: LayoutCardsProtocol  {
        guard let size = view?.frame.size else { return LayoutCardsIPad(sceneSize: CGSize()) }
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return LayoutCardsIPad(sceneSize: size)
        case .phone:
            return LayoutCardsIPhone(sceneSize: size)
        default:
            return LayoutCardsIPhone(sceneSize: size)
        }
    }
}
