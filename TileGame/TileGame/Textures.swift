//
//  Textures.swift
//  TileGame
//
//  Created by Andrei Luca on 9/23/15.
//  Copyright © 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Textures {

    // MARK: Methods

    private static var texturesAreCreated: Bool = false

    static var tileTexture: SKTexture!
    static var starTexture: SKTexture!

    static var headerBackgroundTexture: SKTexture!
    static var headerLeftCornerTexture: SKTexture!
    static var headerRightCornerTexture: SKTexture!

    static var menuBackgroundTexture: SKTexture!
    static var menuLeftButtonTexture: SKTexture!
    static var menuMiddleButtonTexture: SKTexture!
    static var menuRightButtonTexture: SKTexture!
    static var menuTopButtonTexture: SKTexture!

    // MARK: Methods

    static func createTextures() {

        if Textures.texturesAreCreated { return }

        debugPrint("generating textures")

        let view: SKView = SKView(frame: UIScreen.mainScreen().bounds)

        let screenRatio = Constants.screenRatio

        // tile texture
        let roundRectPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Tile.tileLength * screenRatio , Tile.tileLength * screenRatio),
            cornerRadius: Tile.tileCornerRadius * screenRatio).CGPath
        let tileShape = SKShapeNode()
        tileShape.fillColor = UIColor.whiteColor()
        tileShape.path = roundRectPath
        tileTexture = view.textureFromNode(tileShape)

        // star texture
        let starPath = getStarPath(0, y: 0, radius: Tile.tileLength / 2 * screenRatio, sides: 5, pointyness: 2)
        let starShape = SKShapeNode()
        starShape.fillColor = SKColor.whiteColor()
        starShape.path = starPath
        starTexture = view.textureFromNode(starShape)

        // header background texture
        let headerBackgroundPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Constants.screenSize.width * screenRatio, Tile.tileLength * screenRatio),
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight],
            cornerRadii: CGSizeMake(Tile.tileLength * screenRatio / 2, Tile.tileLength * screenRatio / 2))

        let headerBackgroundShape = SKShapeNode()
        headerBackgroundShape.path = headerBackgroundPath.CGPath
        headerBackgroundShape.fillColor = SKColor.whiteColor()
        headerBackgroundTexture = view.textureFromNode(headerBackgroundShape)

        // header left corner texture
        let headerLeftCornerPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Tile.tileLength * screenRatio, Tile.tileLength * screenRatio),
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomRight],
            cornerRadii: CGSizeMake(Tile.tileLength * screenRatio / 2, Tile.tileLength * screenRatio / 2))

        let headerLeftCornerShape = SKShapeNode()
        headerLeftCornerShape.path = headerLeftCornerPath.CGPath
        headerLeftCornerShape.fillColor = SKColor.whiteColor()
        headerLeftCornerTexture = view.textureFromNode(headerLeftCornerShape)

        // header right corner texture
        let headerRightCornerPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Tile.tileLength * screenRatio, Tile.tileLength * screenRatio),
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopRight],
            cornerRadii: CGSizeMake(Tile.tileLength * screenRatio / 2, Tile.tileLength * screenRatio / 2))

        let headerRightCornerShape = SKShapeNode()
        headerRightCornerShape.path = headerRightCornerPath.CGPath
        headerRightCornerShape.fillColor = SKColor.whiteColor()
        headerRightCornerTexture = view.textureFromNode(headerRightCornerShape)

        // menu background texture

        let menuBackgroundSize = CGSizeMake(
            GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x,
            GameScene.boardPositions[1][0].y - GameScene.boardPositions[5][0].y)

        let menuCornerRadius = Tile.tileLength / 4 * 3

        let menuBackgroundPath: UIBezierPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPointZero, size: menuBackgroundSize * screenRatio),
            cornerRadius: menuCornerRadius * screenRatio)

        let menuBackgroundShape = SKShapeNode()
        menuBackgroundShape.fillColor = SKColor.whiteColor()
        menuBackgroundShape.path = menuBackgroundPath.CGPath
        menuBackgroundTexture = view.textureFromNode(menuBackgroundShape)

        // buttons textures

        let buttonMargin = Tile.tileSize.width / 4
        let buttonHeight = (menuBackgroundSize.height - buttonMargin * 4) / 3
        let buttonWidth = (menuBackgroundSize.width - buttonMargin * 4) / 3
        let buttonSize: CGSize = CGSize(width: buttonWidth, height: buttonHeight)
        let buttonCornerRadius = menuCornerRadius - Tile.tileLength / 4

        // left button texture

        let leftButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPointZero, size: buttonSize * screenRatio),
            byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.BottomRight],
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let leftButtonShape = SKShapeNode()
        leftButtonShape.fillColor = UIColor.whiteColor()
        leftButtonShape.path = leftButtonPath.CGPath
        menuLeftButtonTexture = view.textureFromNode(leftButtonShape)

        // middle button texture

        let middleButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPointZero, size: buttonSize * screenRatio),
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let middleButtonShape = SKShapeNode()
        middleButtonShape.fillColor = UIColor.whiteColor()
        middleButtonShape.path = middleButtonPath.CGPath
        menuMiddleButtonTexture = view.textureFromNode(middleButtonShape)

        // right button texture

        let rightButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPointZero, size: buttonSize * screenRatio),
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopRight],
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let rightButtonShape = SKShapeNode()
        rightButtonShape.fillColor = UIColor.whiteColor()
        rightButtonShape.path = rightButtonPath.CGPath
        menuRightButtonTexture = view.textureFromNode(rightButtonShape)

        // top button texture

        let topButtonSize: CGSize = CGSize(width: menuBackgroundSize.width - buttonMargin * 2, height: buttonHeight)

        let topButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPointZero, size: topButtonSize * screenRatio),
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let topButtonShape = SKShapeNode()
        topButtonShape.fillColor = UIColor.whiteColor()
        topButtonShape.path = topButtonPath.CGPath
        menuTopButtonTexture = view.textureFromNode(topButtonShape)
        
        Textures.texturesAreCreated = true
    }
}