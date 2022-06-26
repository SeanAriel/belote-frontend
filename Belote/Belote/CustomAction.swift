//
//  CustomAction.swift
//  Belote
//
//  Created by Sitora Guliamova on 24.05.2022.
//

import UIKit
import SpriteKit

final class CustomAction {
    static func getMoveAction(startPoint: CGPoint, endPoint: CGPoint, speedRange: ClosedRange<CGFloat>, varyingBy: CGFloat) -> SKAction {
        SKAction.follow(
            CGMutablePath.createCurvedPath(
                from: startPoint,
                to: endPoint,
                varyingBy: varyingBy),
            asOffset: false,
            orientToPath: false,
            speed: CGFloat.random(in: speedRange)
        )
    }
    
    static func getWiggleAction(angle: CGFloat, duration: TimeInterval, count: Int) -> SKAction {
        SKAction.repeat(SKAction.sequence(
            [SKAction.rotate(byAngle: angle, duration: duration),
             SKAction.rotate(byAngle: -angle, duration: duration),
             SKAction.rotate(byAngle: -angle, duration: duration),
             SKAction.rotate(byAngle: angle, duration: duration)]
        ), count: count)
    }
}
