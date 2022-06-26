//
//  Operator+increment.swift
//  Belote
//
//  Created by Sitora Guliamova on 23.05.2022.
//

import UIKit

extension Int {
   @discardableResult
   static prefix func ++(x: inout Int) -> Int {
        x += 1
        return x
    }

    static postfix func ++(x: inout  Int) -> Int {
        defer {x += 1}
        return x
    }

    @discardableResult
    static prefix func --(x: inout Int) -> Int {
        x -= 1
        return x
    }

    static postfix func --(x: inout Int) -> Int {
        defer {x -= 1}
        return x
    }
}

extension CGFloat {
   @discardableResult
   static prefix func ++(x: inout CGFloat) -> CGFloat {
        x += 1
        return x
    }

    static postfix func ++(x: inout  CGFloat) -> CGFloat {
        defer {x += 1}
        return x
    }

    @discardableResult
    static prefix func --(x: inout CGFloat) -> CGFloat {
        x -= 1
        return x
    }

    static postfix func --(x: inout CGFloat) -> CGFloat {
        defer {x -= 1}
        return x
    }
}
