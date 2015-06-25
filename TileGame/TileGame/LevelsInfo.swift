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
    var levelsInfo: Array<Array<Int>>!
    var unlockedSections: Int = 0
    var totalSections: Int = 0
    let levelsPerSection = 6
    let starsToPassSection = 9

    // MARK: LevelsInfo
    
    init() {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as Array
        let documentsDirecotry = documentDirectories.first as! String

        levelsInfoPath = documentsDirecotry + "/levelsinfo.json"

        levelsInfo = loadLevelsInfo(levelsInfoPath)
        println(levelsInfo)

        unlockedSections = levelsInfo.count
        totalSections = getTotalSections()
    }

    // MARK: Methods

    private func getTotalSections() -> Int {
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

        println(testDict)

        var data = NSJSONSerialization.dataWithJSONObject(testDict,
            options: NSJSONWritingOptions.allZeros, error: nil)

        NSFileManager.defaultManager().createFileAtPath(levelsInfoPath,
            contents: data, attributes: nil)
    }

    private class func clearJsonFile(levelsInfoPath: String) {
        NSFileManager.defaultManager().removeItemAtPath(levelsInfoPath, error: nil)
    }
    
    private func loadLevelsInfo(levelsInfoPath: String) -> Array<Array<Int>> {
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(levelsInfoPath) {
            if let data = fileManager.contentsAtPath(levelsInfoPath) {
                if let json = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.allZeros,
                    error: nil) as? [String:Array<Array<Int>>] {
                        return json["groups"]!
                }
            }
        }

        return Array(count: 1, repeatedValue: Array(count: 6, repeatedValue: 0))
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
}