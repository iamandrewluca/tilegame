//
//  Enums.swift
//  TileGame
//
//  Created by Andrei Luca on 7/31/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

enum LevelType: Int {
    case FreeTime, LimitedTime, LimitedMoves
}

enum Direction: Int {
    case None = -1, Right, Up, Left, Down
}

enum Orientation: Int {
    case None = -1, Horizontal, Vertical
}

enum ButtonType: String {
    case Lobby = "lobby"
    case Continue = "continue"
    case Restart = "restart"
    case Share = "share"
    case Next = "next"
    case Ad = "ad"
    case Pause = "pause"
}

enum TileType: Int {
    case Hole = -1, Empty, Color1, Color2, Color3, Color4, Color5, Star

    var tileColor: SKColor {
        switch self {
        case .Color1:
            return Constants.Color1
        case .Color2:
            return Constants.Color2
        case .Color3:
            return Constants.Color3
        case .Color4:
            return Constants.Color4
        case .Color5:
            return Constants.Color5
        default:
            return SKColor.clearColor()
        }
    }
}