//
//  LevelInfo.swift
//  TileGame
//
//  Created by Andrei Luca on 7/31/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class LevelInfo {

    init(section: Int, number: Int) {
        self.section = section
        self.number = number
        levelNumber = 1 + number + section * 6
    }

    let section: Int
    let number: Int

    let levelNumber: Int

    var type: LevelType = LevelType.FreeTime
    var typeCounter: Int = 0

    var colorTargets: [TileType:Int] = [
        TileType.Color1:0,
        TileType.Color2:0,
        TileType.Color3:0,
        TileType.Color4:0,
        TileType.Color5:0
    ]

    var starTargets: [TileType:Bool] = [
        TileType.Color1:false,
        TileType.Color2:false,
        TileType.Color3:false,
        TileType.Color4:false,
        TileType.Color5:false
    ]

    var mainTiles: [[TileType]] = Array(count: 6,
        repeatedValue: Array(count: 6,
            repeatedValue: TileType.Empty))

    var childTiles: [[TileType]] = Array(count: 6,
        repeatedValue: Array(count: 6,
            repeatedValue: TileType.Empty))
}