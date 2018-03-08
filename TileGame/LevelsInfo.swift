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

    fileprivate var levelsDataPath: String!
    fileprivate var levelsData: [[Int]]!

    fileprivate(set) var unlockedSections: Int = 0
    fileprivate(set) var totalSections: Int = 0

    let levelsPerSection = 6
    let starsToPassSection = 9

    // MARK: LevelsInfo
    
    fileprivate init() {
        let documentDirectories: [String] = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true) as Array
        let documentsDirecotry = documentDirectories[0]

        levelsDataPath = documentsDirecotry + "/levelsdata.json"

        levelsData = loadLevelsData(levelsDataPath)

        unlockedSections = levelsData.count
        totalSections = getTotalSections()
    }

    // MARK: Methods

    fileprivate func getTotalSections() -> Int {

        guard let path = Bundle.main.path(forResource: "levelsinfo", ofType: "json"),
            let data = FileManager.default.contents(atPath: path) else {
                fatalError("Levels Info file is missing")
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Int]
            return json["total_sections"]!
        } catch {
            return 0
        }
    }

    fileprivate func loadJSONFromBundle(_ filename: String) -> [String:AnyObject] {

        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            fatalError("Could not find level file: \(filename)")
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Could not load level file: \(filename)")
        }

        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            return dict
        } catch {
            fatalError("Level file '\(filename)' is not valid JSON")
        }
    }

    fileprivate class func clearJsonFile(_ levelsInfoPath: String) {
        do {
            try FileManager.default.removeItem(atPath: levelsInfoPath)
        } catch {
            fatalError("can't clear json file")
        }
    }

    fileprivate func saveLevelsData() {

        var levelsDataJSON: [String: [[Int]]] = [:]
        levelsDataJSON["sections"] = levelsData

        do {
//            debugPrint("trying to save")
            let levelsNSData = try JSONSerialization.data(withJSONObject: levelsDataJSON, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            FileManager.default.createFile(atPath: levelsDataPath, contents: levelsNSData, attributes: nil)
        } catch {
            fatalError("Cannot write levels data file")
        }
    }
    
    fileprivate func loadLevelsData(_ levelsInfoPath: String) -> Array<Array<Int>> {

        var levelsInfo = Array(repeating: Array(repeating: 0, count: 6), count: 1)

        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: levelsInfoPath) {

            let data = fileManager.contents(atPath: levelsInfoPath)

            do {
                let json = try JSONSerialization.jsonObject(with: data!,
                    options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Array<Array<Int>>]

                levelsInfo = json["sections"]!
                debugPrint(levelsInfo)
            } catch {}
        }

        return levelsInfo
    }

    func loadLevel(_ section: Int, number: Int) -> LevelInfo {

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
        for i in 0 ..< levelInfo.colorTargets.count {
            levelInfo.colorTargets[TileType(rawValue: i + 1)!] = targets[i]
        }

        // get main and child tile types
        for i in 0 ..< levelInfo.mainTiles.count {
            for j in 0 ..< levelInfo.mainTiles[i].count {

                let value = tiles[i][j]

                if value == -1 {
                    levelInfo.mainTiles[i][j] = TileType.hole
                } else if value != 0 {
                    levelInfo.mainTiles[i][j] = TileType(rawValue: value / 10)!
                    levelInfo.childTiles[i][j] = TileType(rawValue: value % 10)!

                    // check for star
                    if levelInfo.childTiles[i][j] == TileType.star {
                        levelInfo.starTargets[levelInfo.mainTiles[i][j]] = true
                    }
                }
            }
        }
        
        return levelInfo
    }
    
    func starsAtIndexPath(_ indexPath: IndexPath) -> Int {
        return levelsData[indexPath.section][indexPath.item];
    }

    func starsInSection(_ section: Int) -> Int {
        return levelsData[section].reduce(0, +)
    }

    func totalStars() -> Int {
        return levelsData.reduce([], +).reduce(0, +)
    }

    func setLevelStars(_ levelInfo: LevelInfo, stars: Int) {

        if stars > levelsData[levelInfo.section][levelInfo.number] {
            levelsData[levelInfo.section][levelInfo.number] = stars

            if starsInSection(levelInfo.section) >= starsToPassSection {
                debugPrint("maybe new section?")

                if unlockedSections < totalSections && levelInfo.section + 1 == unlockedSections {
                    debugPrint("ok, new section")
                    unlockedSections += 1
                    levelsData.append(Array(repeating: 0, count: 6))
                }
            }
        }

//        debugPrint("save level data")
        saveLevelsData()
    }
}
