//
//  LayoutCards.swift
//  Belote
//
//  Created by Sitora Guliamova on 06.06.2022.
//

import UIKit

protocol LayoutCardsProtocol {
    var cardSize: CGSize { get }
    var pointUser: CGPoint { get }
    var pointAi: CGPoint { get }
    var inHand: InHand { get }
    var inField: InField { get }
    var pointScore: PointScore { get }
}

// MARK: - Model for Layout

struct InHand {
    let user: User
    let ai: Ai
    
    struct User {
        let rect: CGRect
    }
    struct Ai {
        let rect: CGRect
    }
}

struct InField {
    let user: User
    let ai: Ai
    
    struct User {
        let faceUp: CGRect
        let faceDown: CGRect
    }
    struct Ai {
        let faceUp: CGRect
        let faceDown: CGRect
    }
}

struct PointScore {
    let user: CGPoint
    let ai: CGPoint
}

// MARK: - Layout Cards IPad

struct LayoutCardsIPad: LayoutCardsProtocol {
    init(sceneSize: CGSize) {
        let layoutInField = LayoutInField(size: sceneSize, cardSize: cardSize)
        let layoutInHand = LayoutInHand(size: sceneSize, cardSize: cardSize)
        
        self.inField = InField(
            user: InField.User(faceUp: layoutInField.user.faceUp, faceDown: layoutInField.user.faceDown),
            ai: InField.Ai(faceUp: layoutInField.ai.faceUp, faceDown: layoutInField.ai.faceDown)
        )
        self.inHand = InHand(
            user: InHand.User(rect: layoutInHand.user.rect),
            ai: InHand.Ai(rect: layoutInHand.ai.rect)
        )
        self.pointScore = PointScore(
            user: CGPoint(x: layoutInHand.user.rect.maxX + cardSize.width, y: layoutInHand.user.rect.origin.y),
            ai: CGPoint(x: layoutInHand.user.rect.maxX + cardSize.width, y: layoutInHand.ai.rect.origin.y)
        )
    }
    
    var cardSize = CGSize(width: 80, height: 127)
    var pointUser = CGPoint(x: -100, y: 0)
    var pointAi = CGPoint(x: 100, y: 0)
    var pointScore: PointScore
    var inHand: InHand
    var inField: InField
    
    private struct LayoutInHand {
        init(size: CGSize, cardSize: CGSize) {
            let sizeInHand = CGSize(width: size.width * 2.7/4, height: size.height)
            self.user = User(size: sizeInHand, cardSize: cardSize)
            self.ai = Ai(size: sizeInHand, cardSize: cardSize)
        }
        
        let user: User
        let ai: Ai
        
        struct User {
            init(size: CGSize, cardSize: CGSize) {
                let origin = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height / 2 + 10)
                self.rect = CGRect(origin: origin, size: size)
            }

            let rect: CGRect
        }
        struct Ai {
            init(size: CGSize, cardSize: CGSize) {
                let origin = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height / 2 - 10)
                self.rect = CGRect(origin: origin, size: size)
            }

            let rect: CGRect
        }
    }
    
    private struct LayoutInField {
        init(size: CGSize, cardSize: CGSize) {
            let sizeField: CGSize = CGSize(width: size.width * 1.35/4, height: size.height)
            self.user = User(size: sizeField, cardSize: cardSize)
            self.ai = Ai(size: sizeField, cardSize: cardSize)
        }
        
        let user: User
        let ai: Ai
        
        struct User {
            init(size: CGSize, cardSize: CGSize) {
                let originFaceUp: CGPoint = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height * 1.7)
                let originFaceDown: CGPoint = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height * 1.7 + 10)
                
                self.faceUp = CGRect(origin: originFaceUp, size: size)
                self.faceDown = CGRect(origin: originFaceDown, size: size)
            }

            let faceUp: CGRect
            let faceDown: CGRect
        }
        struct Ai {
            init(size: CGSize, cardSize: CGSize) {
                let originFaceUp: CGPoint = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height * 1.7)
                let originFaceDown: CGPoint = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height * 1.7 - 10)
                
                self.faceUp = CGRect(origin: originFaceUp, size: size)
                self.faceDown = CGRect(origin: originFaceDown, size: size)
            }

            let faceUp: CGRect
            let faceDown: CGRect
        }
    }
}

// MARK: - Layout Cards IPhone

struct LayoutCardsIPhone: LayoutCardsProtocol {
    init(sceneSize: CGSize) {
        let layoutInField = LayoutInField(size: sceneSize, cardSize: cardSize)
        let layoutInHand = LayoutInHand(size: sceneSize, cardSize: cardSize)
        
        self.inField = InField(
            user: InField.User(faceUp: layoutInField.user.faceUp, faceDown: layoutInField.user.faceDown),
            ai: InField.Ai(faceUp: layoutInField.ai.faceUp, faceDown: layoutInField.ai.faceDown)
        )
        self.inHand = InHand(
            user: InHand.User(rect: layoutInHand.user.rect),
            ai: InHand.Ai(rect: layoutInHand.ai.rect)
        )
        self.pointScore = PointScore(
            user: CGPoint(x: layoutInHand.user.rect.minX + cardSize.width/2, y: layoutInField.user.faceDown.origin.y),
            ai: CGPoint(x: layoutInHand.ai.rect.minX + cardSize.width/2, y: layoutInField.ai.faceDown.origin.y)
        )
    }
    
    var inHand: InHand
    var inField: InField
    var pointScore: PointScore
    var cardSize = CGSize(width: 50, height: 70)
    var pointUser = CGPoint(x: -50, y: 0)
    var pointAi = CGPoint(x: 50, y: 0)
    
    private struct LayoutInHand {
        init(size: CGSize, cardSize: CGSize) {
            let sizeInHand = CGSize(width: size.width - 10, height: size.height)
            self.user = User(size: sizeInHand, cardSize: cardSize)
            self.ai = Ai(size: sizeInHand, cardSize: cardSize)
        }
        
        let user: User
        let ai: Ai
        
        struct User {
            init(size: CGSize, cardSize: CGSize) {
                let origin = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height / 2 + 10)
                self.rect = CGRect(origin: origin, size: size)
            }

            let rect: CGRect
        }
        struct Ai {
            init(size: CGSize, cardSize: CGSize) {
                let origin = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height / 2 - 10)
                self.rect = CGRect(origin: origin, size: size)
            }

            let rect: CGRect
        }
    }
    
    private struct LayoutInField {
        init(size: CGSize, cardSize: CGSize) {
            let sizeField: CGSize = CGSize(width: 230, height: size.height)
            self.user = User(size: sizeField, cardSize: cardSize)
            self.ai = Ai(size: sizeField, cardSize: cardSize)
        }
        
        let user: User
        let ai: Ai
        
        struct User {
            init(size: CGSize, cardSize: CGSize) {
                let originFaceUp: CGPoint = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height * 2)
                let originFaceDown: CGPoint = CGPoint(x: -size.width / 2, y: size.height / -2 + cardSize.height * 2 + 10)
                
                self.faceUp = CGRect(origin: originFaceUp, size: size)
                self.faceDown = CGRect(origin: originFaceDown, size: size)
            }

            let faceUp: CGRect
            let faceDown: CGRect
        }
        struct Ai {
            init(size: CGSize, cardSize: CGSize) {
                let originFaceUp: CGPoint = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height * 2)
                let originFaceDown: CGPoint = CGPoint(x: -size.width / 2, y: size.height / 2 - cardSize.height * 2 - 10)
                
                self.faceUp = CGRect(origin: originFaceUp, size: size)
                self.faceDown = CGRect(origin: originFaceDown, size: size)
            }

            let faceUp: CGRect
            let faceDown: CGRect
        }
    }
}
