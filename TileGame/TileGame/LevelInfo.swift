//
//  LevelInfo.swift
//  TileGame
//
//  Created by Andrei Luca on 7/31/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class LevelInfo {

    var type: LevelType = LevelType.FreeTime
    var typeCounter: Int = 0

    var colorTargets: [TileType:Int] = [
        TileType.Color1:0,
        TileType.Color2:0,
        TileType.Color3:0,
        TileType.Color4:0,
        TileType.Color5:0
    ]

    var mainTiles: [[TileType]] = Array(count: 6,
        repeatedValue: Array(count: 6,
            repeatedValue: TileType.Hole))

    var childTiles: [[TileType]] = Array(count: 6,
        repeatedValue: Array(count: 6,
            repeatedValue: TileType.Hole))
}