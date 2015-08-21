//
//  LevelInfo.swift
//  TileGame
//
//  Created by Andrei Luca on 7/31/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class LevelInfo {

    init(level: (section: Int, number: Int)) {
        self.level = level
        levelNumber = 1 + level.number + level.section * 6
    }

    var level: (section: Int, number: Int)!

    var levelNumber: Int

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
            repeatedValue: TileType.Empty))

    var childTiles: [[TileType]] = Array(count: 6,
        repeatedValue: Array(count: 6,
            repeatedValue: TileType.Empty))
}