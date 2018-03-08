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
    case freeTime, limitedTime, limitedMoves
}

enum Direction: Int {
    case none = -1, right, up, left, down
}

enum Axis: Int {
    case none = -1, horizontal, vertical
}

enum ButtonType: String {
    case Lobby = "lobby"
    case Continue = "continue"
    case Restart = "restart"
    case Share = "share"
    case Next = "next"
    case Ad = "ad"
    case Pause = "pause"
    case Overlay = "overlay"
    case Empty = ""
}

enum TileType: Int {
    case hole = -1, empty, color1, color2, color3, color4, color5, star

    var tileColor: SKColor {
        switch self {
        case .color1:
            return Constants.Color1
        case .color2:
            return Constants.Color2
        case .color3:
            return Constants.Color3
        case .color4:
            return Constants.Color4
        case .color5:
            return Constants.Color5
        default:
            return SKColor.clear
        }
    }
}
