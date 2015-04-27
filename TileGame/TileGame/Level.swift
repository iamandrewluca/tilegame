//
//  Level.swift
//  TileGame
//
//  Created by Andrei Luca on 16/04/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class Level {
    
    var section = 0
    var level = 0
    
    var levelType: LevelType? = LevelType.FreeTime
    var levelTypeCounter: Int = 0
    
    var mainTiles = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: TileType.Unknown))
    var childTiles = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: TileType.Unknown))
    var colorTargets = Array(count: 5, repeatedValue: 0)
    var colorStars = Array(count: 5, repeatedValue: false)
    
    init(levelNumber: Int, sectionNumber: Int) {
        level = levelNumber
        section = sectionNumber
        
        populateLevel()
    }
    
    func populateLevel() {
        
        if let level = loadJSONFromBundle("section_\(section)_level_\(level)") {
            
            // get level type
            if let type = level["levelType"] as? Int, counter = level["levelTypeCounter"] as? Int {
                levelType = LevelType(rawValue: type)
                levelTypeCounter = counter
                
            }
            
            // get tiles targets
            if let targets = level["colorTargets"] as? Array<Int> {
                for var i = 0; i < colorTargets.count; ++i {
                    colorTargets[i] = targets[i]
                }
            }
            
            // get main and child tile types
            if let tiles = level["tiles"] as? Array<Array<Int>> {
                for var i = 0; i < tiles.count; ++i {
                    for var j = 0; j < tiles[i].count; ++j {
                        mainTiles[i][j] = TileType(rawValue: tiles[i][j] / 10)!
                        childTiles[i][j] = TileType(rawValue: tiles[i][j] % 10)!
                    }
                }
            }
        }
    }
    
    func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            var error: NSError?
            let data: NSData? = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: &error)
            if let data = data {
                
                let dictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return dictionary
                } else {
                    println("Level file '\(filename)' is not valid JSON: \(error!)")
                    return nil
                }
            } else {
                println("Could not load level file: \(filename), error: \(error!)")
                return nil
            }
        } else {
            println("Could not find level file: \(filename)")
            return nil
        }
    }
    
}

enum LevelType: Int {
    case FreeTime = 0, LimitedTime, LimitedMoves
}