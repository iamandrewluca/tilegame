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

    // MARK: Members

    var strokeBackground: SKSpriteNode?
    var background: SKSpriteNode?

    var button1: SKSpriteNode?
    var button2: SKSpriteNode?
    var button3: SKSpriteNode?

    var topLabel: SKLabelNode?
    var middleLabel: SKLabelNode?

    // MARK: SKNode

    override init() {
        super.init()

        userInteractionEnabled = true

        // first background
        var menuWidth = Constants.boardPositions[5][5].x -
            Constants.boardPositions[5][0].x

        var menuHeight = Constants.boardPositions[1][0].y -
            Constants.boardPositions[5][0].y

        var menuSize = CGSizeMake(menuWidth, menuHeight)

        var menuBackShape = SKShapeNode();
        menuBackShape.fillColor = SKColor.grayColor()
        menuBackShape.strokeColor = SKColor.grayColor()
        menuBackShape.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, menuWidth, menuHeight),
            cornerRadius: Constants.tileCornerRadius).CGPath

        let menuBack = SKSpriteNode(texture: Constants.sceneView?.textureFromNode(menuBackShape), size: menuSize)

        menuBack.position = Constants.boardPositions[5][0]
        menuBack.anchorPoint = CGPointZero

        // second background

        menuWidth = menuWidth - Constants.tileSize.width / 4
        menuHeight = menuHeight - Constants.tileSize.height / 4
        menuSize = CGSizeMake(menuWidth, menuHeight)

        menuBackShape = SKShapeNode();
        menuBackShape.fillColor = SKColor.whiteColor()

        let corner = Constants.tileCornerRadius// - Constants.tileSize.width / 8

        menuBackShape.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, menuWidth, menuHeight),
            cornerRadius: corner).CGPath

        let secondBack = SKSpriteNode(texture: Constants.sceneView?.textureFromNode(menuBackShape), size: menuSize)
        secondBack.anchorPoint = CGPointZero
        secondBack.position = CGPointMake(Constants.tileSize.width / 8, Constants.tileSize.height / 8)

        var middle = SKSpriteNode(color: SKColor.grayColor(), size: CGSizeMake(menuWidth, menuHeight/3))
        middle.anchorPoint = CGPointZero
        middle.position.y = menuHeight / 3

        secondBack.addChild(middle)
        menuBack.addChild(secondBack)

        addChild(menuBack)

        // add buttons

        let buttonMargin = Constants.tileSize.width / 8
        let buttonHeight = menuHeight / 3 - buttonMargin * 2
        let buttonWidth = (menuWidth - 4 * buttonMargin) / 3

        let button1 = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(buttonWidth, buttonHeight))
        let button2 = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(buttonWidth, buttonHeight))
        let button3 = SKSpriteNode(color: SKColor.blueColor(), size: CGSizeMake(buttonWidth, buttonHeight))

        button1.name = ButtonType.Lobby.rawValue
        button2.name = ButtonType.Continue.rawValue
        button3.name = ButtonType.Restart.rawValue

        button1.anchorPoint = CGPointZero
        button2.anchorPoint = CGPointZero
        button3.anchorPoint = CGPointZero

        button1.position.y += buttonMargin
        button2.position.y += buttonMargin
        button3.position.y += buttonMargin

        button1.position.x += buttonMargin
        button2.position.x += buttonMargin * 2 + buttonWidth
        button3.position.x += buttonMargin * 3 + buttonWidth * 2

        secondBack.addChild(button1)
        secondBack.addChild(button2)
        secondBack.addChild(button3)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Touches

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        //
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let location = (touches.first as! UITouch).locationInNode(self)
        let node = nodeAtPoint(location)

        if node.name == ButtonType.Lobby.rawValue {
            (scene as! GameScene).goToLobby()
        }

        if node.name == ButtonType.Continue.rawValue {
            (scene as! GameScene).toogleMenu()
        }

        if node.name == ButtonType.Restart.rawValue {
            // restart
        }

        if node.name == ButtonType.Share.rawValue {
            // share
        }

        if node.name == ButtonType.Next.rawValue {
            // next
        }

        if node.name == ButtonType.Ad.rawValue {
            // video ad
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        //
    }

    enum ButtonType: String {
        case Lobby = "lobby"
        case Continue = "continue"
        case Restart = "restart"
        case Share = "share"
        case Next = "next"
        case Ad = "ad"
    }
}