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

    var type: LevelType = LevelType.freeTime
    var typeCounter: Int = 0

    var colorTargets: [TileType:Int] = [
        TileType.color1:0,
        TileType.color2:0,
        TileType.color3:0,
        TileType.color4:0,
        TileType.color5:0
    ]

    var starTargets: [TileType:Bool] = [
        TileType.color1:false,
        TileType.color2:false,
        TileType.color3:false,
        TileType.color4:false,
        TileType.color5:false
    ]

    var mainTiles: [[TileType]] = Array(repeating: Array(repeating: TileType.empty,
            count: 6),
        count: 6)

    var childTiles: [[TileType]] = Array(repeating: Array(repeating: TileType.empty,
            count: 6),
        count: 6)
}
