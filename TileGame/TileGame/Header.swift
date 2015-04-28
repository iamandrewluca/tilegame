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
    let levelTopLabel = SKLabelNode(text: "10")
    let levelBottomLabel = SKLabelNode(text: "LEVEL")
    
    override init() {
        super.init()
        
        self.position = CGPointMake(0, Constants.sceneSize.height - Constants.tileSize.width)
        
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
        
        // add right icon
        let rightIcon = SKSpriteNode(
            texture: Constants.tile2RoundCornersTexture,
            color: SKColor.whiteColor(),
            size: Constants.tileSize)
        
        rightIcon.anchorPoint = CGPointMake(1.0, 0)
        rightIcon.position = CGPointMake(Constants.sceneSize.width, Constants.tileSize.width)
        rightIcon.zRotation = Constants.degree2radian(90)
        addChild(rightIcon)
        
        // add tileStars
        
        
        // add labels
        for var i = 0; i < Constants.headerPositions.count; ++i {    
            colorLabels[i] = SKLabelNode()
            colorLabels[i]!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            colorLabels[i]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            colorLabels[i]!.text = "0/0"
            colorLabels[i]!.fontSize = 16
            colorLabels[i]!.position = Constants.headerPositions[i]
            colorLabels[i]!.position.y -= 10
            addChild(colorLabels[i]!)
        }
        
        //var spr = SKSpriteNode(texture: Constants.tile2RoundCorners, size: CGSizeMake(45, 45))
        //spr.anchorPoint = CGPointMake(0, 0)
        //addChild(spr)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}