//
//  Helpers.swift
//  TileGame
//
//  Created by Andrei Luca on 17/04/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x - rhs.x, lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x + rhs.x, lhs.y + rhs.y)
}

func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPointMake(lhs.x / rhs, lhs.y / rhs)
}

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func !=(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x != rhs.x && lhs.y != rhs.y
}

func clamp(minLimit: CGFloat, maxLimit: CGFloat, value: CGFloat) -> CGFloat {
    return max(minLimit, min(value, maxLimit))
}

extension CGFloat {
    mutating func roundDecimals(#numberOfDecimals: Int) {
        let multiplier = pow(10.0, CGFloat(numberOfDecimals))
        self = round(self * multiplier) / multiplier
    }
}

func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    var multipliedSize = lhs
    multipliedSize.width *= rhs
    multipliedSize.height *= rhs
    return multipliedSize
}