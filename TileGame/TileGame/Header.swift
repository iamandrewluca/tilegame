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
    
    var headerPositions = Array(count: 5, repeatedValue: CGPointZero)
    
    override init() {
        super.init()
        
        for var i = 0; i < headerPositions.count; ++i {
            headerPositions[i] = CGPointMake(50 + CGFloat(i) * 50.0, 50)
            
            colorLabels[i] = SKLabelNode()
            colorLabels[i]!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            colorLabels[i]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            colorLabels[i]!.text = "0/0"
            colorLabels[i]!.fontSize = 24
            colorLabels[i]!.position = headerPositions[i]
            addChild(colorLabels[i]!)
        }
        var spr = SKSpriteNode(texture: Constants.tile2RoundCorners, size: CGSizeMake(85, 85))
        spr.position.x = 100
        spr.position.y = 50
        addChild(spr)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}