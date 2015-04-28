//
//  Header.swift
//  TileGame
//
//  Created by Andrei Luca on 4/27/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Header: SKNode {
    
    var colorLabels = Array(count: 5, repeatedValue: SKLabelNode?.None)
    var levelTopLabel = SKLabelNode()
    var levelBottomLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        self.position = CGPointMake(0, Constants.sceneSize.height - Constants.tileSize.width)
        userInteractionEnabled = true
        
        // add header background
        let headerBackground = SKSpriteNode(
            texture: Constants.headerTexture,
            color: SKColor.grayColor(),
            size: CGSizeMake(Constants.sceneSize.width, Constants.tileSize.width))
        
        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        addChild(headerBackground)
        
        // add left icon
        let leftIcon = SKSpriteNode(
            texture: Constants.tile2RoundCornersTexture,
            color: SKColor.whiteColor(),
            size: Constants.tileSize)
        
        leftIcon.anchorPoint = CGPointZero
        addChild(leftIcon)
        
        // add labels to left icon
        let pos = CGPointMake(Constants.tileSize.width / 2, Constants.tileSize.width / 2)
        
        levelTopLabel.position = pos
        levelTopLabel.position.y += 5
        levelTopLabel.fontColor = SKColor.blackColor()
        levelTopLabel.fontSize = 16
        levelTopLabel.text = "10"
        levelTopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelTopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center

        levelBottomLabel.position = pos
        levelBottomLabel.position.y -= 8
        levelBottomLabel.fontColor = SKColor.blackColor()
        levelBottomLabel.fontSize = 8
        levelBottomLabel.text = "LEVEL"
        levelBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        leftIcon.addChild(levelTopLabel)
        leftIcon.addChild(levelBottomLabel)
        
        // add right icon
        let rightIcon = SKSpriteNode(
            texture: Constants.tile2RoundCornersTexture,
            color: SKColor.whiteColor(),
            size: Constants.tileSize)
        
        rightIcon.anchorPoint = CGPointMake(1.0, 0)
        rightIcon.position = CGPointMake(Constants.sceneSize.width, Constants.tileSize.width)
        rightIcon.zRotation = Constants.degree2radian(90)
        rightIcon.name = "pause"
        addChild(rightIcon)
        
        // add pause to right icon
        let pause = SKSpriteNode(
            texture: Constants.pauseTexture,
            color: SKColor.blackColor(),
            size: CGSizeMake(Constants.tileSize.width / 2, Constants.tileSize.width / 2))
        
        pause.zRotation = Constants.degree2radian(90)
        pause.position = CGPointMake(-Constants.tileSize.width / 2, Constants.tileSize.width / 2)
        rightIcon.addChild(pause)
        
        for var i = 0; i < Constants.headerPositions.count; ++i {
            
            // add labels
            colorLabels[i] = SKLabelNode()
            colorLabels[i]!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            colorLabels[i]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            colorLabels[i]!.text = "0/0"
            colorLabels[i]!.fontSize = 10
            colorLabels[i]!.position = Constants.headerPositions[i]
            colorLabels[i]!.position.y -= Constants.tileSize.width / 3
            addChild(colorLabels[i]!)
            
            // add tileStars
            var tileStar = SKSpriteNode(
                texture: Constants.tileStarTexture,
                color: TileType(rawValue: i + 1)?.tileColor,
                size: CGSizeMake(Constants.tileSize.width / 2, Constants.tileSize.width / 2))
            
            tileStar.colorBlendFactor = 1.0
            tileStar.position = Constants.headerPositions[i]
            tileStar.position.y += Constants.tileSize.width / 8
            addChild(tileStar)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInNode(self)
        let node = self.nodeAtPoint(point)
        
        if node.name == "pause" {
            println("pause")
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        //
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        //
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}