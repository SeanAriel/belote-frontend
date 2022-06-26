//
//  CGMutablePath+CurvedPath.swift
//  Belote
//
//  Created by Sitora Guliamova on 20.05.2022.
//

import SpriteKit

extension CGMutablePath {
    static func createCurvedPath(from start: CGPoint, to end: CGPoint, varyingBy offset: CGFloat) -> CGMutablePath {
        let pathToMove = CGMutablePath()
        pathToMove.move(to: start)
        let controlPoint = CGPoint(x: CGFloat.random(in: 0...offset) - offset / 2,
                                   y: CGFloat.random(in: 0...offset) - offset / 2)
        pathToMove.addQuadCurve(to: end, control: controlPoint)
        return pathToMove
    }
}


