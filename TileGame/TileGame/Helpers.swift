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