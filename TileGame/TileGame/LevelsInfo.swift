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

    private var levelsDataPath: String!
    private var levelsData: [[Int]]!

    private(set) var unlockedSections: Int = 0
    private(set) var totalSections: Int = 0

    let levelsPerSection = 6
    let starsToPassSection = 9

    // MARK: LevelsInfo
    
    private init() {
        let documentDirectories: [String] = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as Array
        let documentsDirecotry = documentDirectories[0]

        levelsDataPath = documentsDirecotry + "/levelsdata.json"

        levelsData = loadLevelsData(levelsDataPath)

        unlockedSections = levelsData.count
        totalSections = getTotalSections()
    }

    // MARK: Methods

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

    private func saveLevelsData() {

        var levelsDataJSON: [String: [[Int]]] = [:]
        levelsDataJSON["sections"] = levelsData

        do {
            debugPrint("trying to save")
            let levelsNSData = try NSJSONSerialization.dataWithJSONObject(levelsDataJSON, options: NSJSONWritingOptions.init(rawValue: 0))
            NSFileManager.defaultManager().createFileAtPath(levelsDataPath, contents: levelsNSData, attributes: nil)
        } catch {
            fatalError("Cannot write levels data file")
        }
    }
    
    private func loadLevelsData(levelsInfoPath: String) -> Array<Array<Int>> {

        var levelsInfo = Array(count: 1, repeatedValue: Array(count: 6, repeatedValue: 0))

        let fileManager = NSFileManager.defaultManager()

        if fileManager.fileExistsAtPath(levelsInfoPath) {

            let data = fileManager.contentsAtPath(levelsInfoPath)

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.MutableContainers) as! [String:Array<Array<Int>>]

                levelsInfo = json["sections"]!
                debugPrint(levelsInfo)
            } catch {}
        }

        return levelsInfo
    }

    func loadLevel(section: Int, number: Int) -> LevelInfo {

        let levelJSON = loadJSONFromBundle("section_\(section)_level_\(number)")

        let levelInfo = LevelInfo(section: section, number: number)

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

                    // check for star
                    if levelInfo.childTiles[i][j] == TileType.Star {
                        levelInfo.starTargets[levelInfo.mainTiles[i][j]] = true
                    }
                }
            }
        }
        
        return levelInfo
    }
    
    func starsAtIndexPath(indexPath: NSIndexPath) -> Int {
        return levelsData[indexPath.section][indexPath.item];
    }

    func starsInSection(section: Int) -> Int {
        return levelsData[section].reduce(0, combine: +)
    }

    func totalStars() -> Int {
        return levelsData.reduce([], combine: +).reduce(0, combine: +)
    }

    func setLevelStars(levelInfo: LevelInfo, stars: Int) {

        if stars > levelsData[levelInfo.section][levelInfo.number] {
            levelsData[levelInfo.section][levelInfo.number] = stars

            if starsInSection(levelInfo.section) >= starsToPassSection {

                if unlockedSections < totalSections && levelInfo.section + 1 == unlockedSections {
                    unlockedSections++
                    levelsData.append(Array(count: 6, repeatedValue: 0))
                }
            }
        }

        debugPrint("save level data")
        saveLevelsData()
    }
}