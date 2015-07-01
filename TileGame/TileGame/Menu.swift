//
//  Menu.swift
//  TileGame
//
//  Created by Andrei Luca on 6/24/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {

    override init() {
        super.init()

        // first background
        var menuWidth = Constants.boardPositions[1][4].x -
            Constants.boardPositions[1][1].x +
            Constants.tileSize.width

        var menuHeight = Constants.boardPositions[1][1].y -
            Constants.boardPositions[3][1].y +
            Constants.tileSize.height

        var menuSize = CGSizeMake(menuWidth, menuHeight)

        var menuBackShape = SKShapeNode();
        menuBackShape.fillColor = SKColor.grayColor()
        menuBackShape.strokeColor = SKColor.grayColor()
        menuBackShape.path = UIBezierPath(roundedRect: CGRectMake(0, 0, menuWidth, menuHeight), cornerRadius: Constants.tileCornerRadius).CGPath

        let menuBack = SKSpriteNode(texture: Constants.sceneView?.textureFromNode(menuBackShape), size: menuSize)

        menuBack.position = Constants.boardPositions[1][1]
        menuBack.position.x -= Constants.tileSize.width / 2
        menuBack.position.y += Constants.tileSize.height / 2
        menuBack.anchorPoint = CGPointMake(0, 1)

        // second background

        menuWidth = menuWidth - Constants.tileSize.width / 4
        menuHeight = menuHeight - Constants.tileSize.height / 4
        menuSize = CGSizeMake(menuWidth, menuHeight)

        menuBackShape = SKShapeNode();
        menuBackShape.fillColor = SKColor.whiteColor()

        let corner = Constants.tileCornerRadius - Constants.tileSize.width / 8

        menuBackShape.path = UIBezierPath(roundedRect: CGRectMake(0, 0, menuWidth, menuHeight), cornerRadius: corner).CGPath

        let secondBack = SKSpriteNode(texture: Constants.sceneView?.textureFromNode(menuBackShape), size: menuSize)
        secondBack.anchorPoint = CGPointMake(0, 1)
        secondBack.position = CGPointMake(Constants.tileSize.width / 8, -Constants.tileSize.height / 8)
        menuBack.addChild(secondBack)

        addChild(menuBack)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}