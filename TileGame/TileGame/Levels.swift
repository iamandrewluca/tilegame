//
//  Levels.swift
//  TileGame
//
//  Created by Andrei Luca on 6/8/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class Levels {
    
    var levelsInfo: Array<Array<Int>>
    var levelsInfoPath: String
    var unlockedSections: Int
    var totalSections: Int
    
    init() {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as Array
        let documentsDirecotry = documentDirectories.first as! String
        levelsInfoPath = documentsDirecotry + "/levelsinfo.json"

        levelsInfo = Levels.loadLevels(levelsInfoPath)

        unlockedSections = levelsInfo.count
        totalSections = Levels.getTotalSections()
        println(totalSections)
    }

    private class func getTotalSections() -> Int {
        if let path = NSBundle.mainBundle().pathForResource("levelsinfo", ofType: "json") {
            if let data = NSFileManager.defaultManager().contentsAtPath(path) {
                if let json = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.allZeros, error: nil) as? [String:Int] {
                        return json["total_sections"]!
                }
            }
        }

        return 0
    }

    private func createTestJson() {
        var testDict = Dictionary<String, Array<Array<Int>>>()
        var level = Array<Int>()
        level.append(3)
        level.append(4)
        level.append(5)
        var group = Array<Array<Int>>()
        group.append(level)
        group.append(level)
        testDict["groups"] = group

        println(testDict)

        var data = NSJSONSerialization.dataWithJSONObject(testDict,
            options: NSJSONWritingOptions.allZeros, error: nil)

        NSFileManager.defaultManager().createFileAtPath(levelsInfoPath,
            contents: data, attributes: nil)
    }

    private func clearJsonFile() {
        NSFileManager.defaultManager().removeItemAtPath(levelsInfoPath, error: nil)
    }
    
    private class func loadLevels(levelsInfoPath: String) -> Array<Array<Int>> {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(levelsInfoPath) {
            println("file exists")
            if let data = fileManager.contentsAtPath(levelsInfoPath) {
                println("data loaded")
                if let json = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.allZeros,
                    error: nil) as? [String:Array<Array<Int>>] {
                        return json["groups"]!
                }
            }
        }

        return Array<Array<Int>>()
    }
    
    func starsInSection(section: Int, level: Int) -> Int {
        if level > 5 || level < 0 {
            return 0
        }
        if section >= unlockedSections || section < 0 {
            return 0
        }

        return levelsInfo[section][level]
    }
}