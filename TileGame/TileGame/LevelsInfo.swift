//
//  LevelsInfo.swift
//  TileGame
//
//  Created by Andrei Luca on 6/8/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class LevelsInfo {

    // MARK: Members

    static let sharedInstance: LevelsInfo! = LevelsInfo()
    var levelsInfoPath: String!
    var levelsInfo: [[Int]]!
    var unlockedSections: Int = 0
    var totalSections: Int = 0
    let levelsPerSection = 6
    let starsToPassSection = 9

    // MARK: LevelsInfo
    
    init() {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as Array
        let documentsDirecotry = documentDirectories.first as String!

        levelsInfoPath = documentsDirecotry + "/levelsinfo.json"

        levelsInfo = loadLevelsInfo(levelsInfoPath)

        unlockedSections = levelsInfo.count
        totalSections = getTotalSections()
    }

    // MARK: Methods

    func loadLevel(level: (section: Int, number: Int)) -> LevelInfo {

        let levelInfo = LevelInfo(level: level)

        let levelJSON = loadJSONFromBundle("section_\(level.section)_level_\(level.number)")

        guard let type = levelJSON["levelType"] as? Int,
            let counter = levelJSON["levelTypeCounter"] as? Int,
            let targets = levelJSON["colorTargets"] as? [Int],
            let tiles = levelJSON["tiles"] as? [[Int]] else {
                return levelInfo
        }

        // get level type
        levelInfo.type = LevelType(rawValue: type)!
        levelInfo.typeCounter = counter

        // get tiles targets
        for var i = 0; i < targets.count && i < levelInfo.colorTargets.count; ++i {
            levelInfo.colorTargets[TileType(rawValue: i + 1)!] = targets[i]
        }

        // get main and child tile types
        for var i = 0; i < tiles.count && i < levelInfo.mainTiles.count; ++i {
            for var j = 0; j < tiles[i].count && i < levelInfo.mainTiles[i].count; ++j {

                let value = tiles[i][j]

                if value == -1 {
                    levelInfo.mainTiles[i][j] = TileType.Hole
                } else if value != 0 {
                    levelInfo.mainTiles[i][j] = TileType(rawValue: value / 10)!
                    levelInfo.childTiles[i][j] = TileType(rawValue: value % 10)!
                }
            }
        }

        return levelInfo
    }

    private func getTotalSections() -> Int {

        guard let path = NSBundle.mainBundle().pathForResource("levelsinfo", ofType: "json"),
            let data = NSFileManager.defaultManager().contentsAtPath(path) else {
                fatalError("Levels Info file is missing")
        }

        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String:Int]
            return json["total_sections"]!
        } catch {
            return 0
        }
    }

    private class func createTestJson(levelsInfoPath: String) {
        var testDict = Dictionary<String, Array<Array<Int>>>()
        var level = Array<Int>()
        level.append(0)
        level.append(1)
        level.append(2)
        level.append(3)
        level.append(4)
        level.append(5)
        var group = Array<Array<Int>>()
        group.append(level)
        group.append(level)
        testDict["groups"] = group

        debugPrint(testDict)

        do {
            let data = try NSJSONSerialization.dataWithJSONObject(testDict, options: NSJSONWritingOptions.PrettyPrinted)
            NSFileManager.defaultManager().createFileAtPath(levelsInfoPath, contents: data, attributes: nil)
        } catch {
            fatalError("can't write demo json")
        }
    }

    private func loadJSONFromBundle(filename: String) -> [String:AnyObject] {

        guard let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") else {
            fatalError("Could not find level file: \(filename)")
        }

        guard let data = NSData(contentsOfFile: path) else {
            fatalError("Could not load level file: \(filename)")
        }

        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            return dict
        } catch {
            fatalError("Level file '\(filename)' is not valid JSON")
        }
    }

    private class func clearJsonFile(levelsInfoPath: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(levelsInfoPath)
        } catch {
            fatalError("can't clear json file")
        }
    }
    
    private func loadLevelsInfo(levelsInfoPath: String) -> Array<Array<Int>> {

        var levelsInfo = Array(count: 1, repeatedValue: Array(count: 6, repeatedValue: 0))

        let fileManager = NSFileManager.defaultManager()

        if fileManager.fileExistsAtPath(levelsInfoPath) {

            let data = fileManager.contentsAtPath(levelsInfoPath)

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.MutableContainers) as! [String:Array<Array<Int>>]

                levelsInfo = json["groups"]!
            } catch {}
        }
        return levelsInfo
    }
    
    func starsAtIndexPath(indexPath: NSIndexPath) -> Int {

        if indexPath.section >= 0 &&
            indexPath.section < unlockedSections &&
            indexPath.item >= 0 &&
            indexPath.item < 6 {
                return levelsInfo[indexPath.section][indexPath.item];
        }

        return 0
    }

    func starsInSection(section: Int) -> Int {

        if section >= 0 && section < unlockedSections {
            return levelsInfo[section].reduce(0, combine: +)
        }

        return 0
    }

    func totalStars() -> Int {
        return levelsInfo.reduce([], combine: +).reduce(0, combine: +)
    }
}