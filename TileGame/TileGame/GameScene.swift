//
//  GameScene.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {

    // MARK: Members - Parent Controller

    weak var parentController: GameViewController!

    // MARK: Members - Static Textures

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

    // MARK: Members - Game Info

    var levelsInfo: LevelsInfo = LevelsInfo.sharedInstance
    var levelInfo: LevelInfo!
    var level: (section: Int, number: Int)!

    // MARK: Members - Header
    var headerPositions: [TileType:CGPoint] = [:]

    var topTileNodes: [TileType:SKSpriteNode] = [:]
    var colorLabels: [TileType:SKLabelNode] = [:]
    var headerTopLabel: SKLabelNode = SKLabelNode()
    var headerBottomLabel: SKLabelNode = SKLabelNode()

    // MARK: Members - Overlay

    var overlay: SKSpriteNode!

    // MARK: Members - Menu

    var menu: SKSpriteNode!

    var menuLeftButton: SKSpriteNode!
    var menuMiddleButton: SKSpriteNode!
    var menuRightButton: SKSpriteNode!
    var menuTopButton: SKSpriteNode!

    // MARK: Members - Board

    static let boardSize: Int = 6

    static let boardPositions: [[CGPoint]] = { () -> [[CGPoint]] in

        let boardHorizontalMargin = (Constants.screenSize.width - 6 * Tile.tileLength - 5 * Tile.tileSpacing) / 2
        let boardVerticalMargin = (Constants.screenSize.height - Constants.screenSize.width) / 2 +
            boardHorizontalMargin + Tile.tileLength / 2

        var board = Array(count: boardSize,
            repeatedValue: Array(count: boardSize,
                repeatedValue: CGPoint.zeroPoint))

        for i in 0 ..< boardSize {
            for j in 0 ..< boardSize {
                board[i][j] = CGPoint(
                    x: boardHorizontalMargin + Tile.tileLength / 2 + CGFloat(j) * (Tile.tileSpacing + Tile.tileLength),
                    y: boardVerticalMargin + CGFloat(boardSize - 1 - i) * (Tile.tileSpacing + Tile.tileLength))
            }
        }

        return board
        }()

    var tiles: [[Tile?]] = []

    // MARK: Members - Game State

    var limits: [Direction:(row: Int, column: Int)] = [
        Direction.Up: (row: 0, column: 0),
        Direction.Right: (row: 0, column: 0),
        Direction.Down: (row: 0, column: 0),
        Direction.Left: (row: 0, column: 0)
    ]

    var startTouchPosition: CGPoint = CGPointZero
    var lastTouchPosition: CGPoint = CGPointZero
    var startTilePoint: CGPoint = CGPointZero
    var endTilePoint: CGPoint = CGPointZero

    var currentDirection: Direction = Direction.None
    var fromDirection: Direction = Direction.None
    var toDirection: Direction = Direction.None

    var counter: Counter!
    var moves: Int = 0
    var currentTargets: [TileType:Int] = [:]
    var currentStars: [TileType:Bool] = [:]

    var menuIsClosed: Bool = true
    var gameIsStarted: Bool = false
    var gameIsOver: Bool = false
    var gameIsWon: Bool = false
    var gameIsPaused: Bool = false
    var canSwipe: Bool = true

    var currentSwipedTile: Tile?

    // MARK: Override - SKScene

    deinit {
        debugPrint("GameScene deinit")
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        /* Setup your scene here */

        levelInfo = levelsInfo.loadLevel(level)

        backgroundColor = Constants.backgroundColor

        createOverlay()

        createMenu()

        createHeader()

        createBoard()

        prepareGame()
    }

    // MARK: Override - UIResponder

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        if node.name == "overlay" {
            toogleMenu()
        }

        if node.name == ButtonType.Pause.rawValue {
            toogleMenu()
        }

        if node.name == ButtonType.Lobby.rawValue {
            goToLobby()
        }

        if node.name == ButtonType.Continue.rawValue {
            toogleMenu()
        }

        if node.name == ButtonType.Restart.rawValue {
            restartLevel()
        }

        if node.name == ButtonType.Share.rawValue {
            share()
        }

        if node.name == ButtonType.Next.rawValue {
            nextLevel()
        }

        if node.name == ButtonType.Ad.rawValue {
            showAd()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
    }

    // MARK: Methods - Tile Drag

    func tileDragBegan(tile: Tile, at position: CGPoint) {

        if !gameIsStarted {
            startGame()
            gameIsStarted = true
        }

        if currentSwipedTile != nil { return }
        currentSwipedTile = tile

        calculateLimits(tile)

        startTouchPosition = position
        lastTouchPosition = startTouchPosition

        fromDirection = Direction.None
        toDirection = Direction.None
        currentDirection = Direction.None
    }

    func tileDragMoved(tile: Tile, at position: CGPoint) {

        if currentSwipedTile != tile { return }

        let currentTouchPosition = position

        if toDirection == Direction.None {

            let deltaFromStart = currentTouchPosition - startTouchPosition

            getDirections(deltaFromStart)

            startTilePoint = getPlacePosition(tile.place)
            endTilePoint = getPlacePosition(limits[toDirection]!)
        }

        if tile.place == limits[toDirection]! {
            currentSwipedTile = nil
            return
        }

        tile.position.x = clamp(startTilePoint.x, endTilePoint.x, currentTouchPosition.x)
        tile.position.y = clamp(startTilePoint.y, endTilePoint.y, currentTouchPosition.y)

        lastTouchPosition = currentTouchPosition
    }

    func tileDragEnded(tile: Tile, at position: CGPoint) {

        if currentSwipedTile != tile { return }
        if toDirection == Direction.None { return }

        tile.runAction(SKAction.moveTo(endTilePoint, duration: 0.1)) { [unowned self] in

            let startPlace = self.currentSwipedTile!.place
            let endPlace = self.limits[self.toDirection]!

            self.tiles[endPlace.row][endPlace.column] = self.currentSwipedTile
            self.tiles[startPlace.row][startPlace.column] = nil
            self.currentSwipedTile!.place = endPlace

            self.tileWasMoved(tile)

            self.currentSwipedTile = nil
            self.fromDirection = Direction.None
            self.toDirection = Direction.None
            self.currentDirection = Direction.None
        }
    }

    // MARK: Methods - Tile Methods

    func tileWasMoved(tile: Tile) {

        moves++

        if levelInfo.type == LevelType.LimitedMoves {
            headerTopLabel.text = "\(levelInfo.typeCounter - moves)"

            if moves >= levelInfo.typeCounter {
                gameOver()
            }
        }

        var tilesToCheck: [Tile] = [tile]
        checkTilesAndDestroy(&tilesToCheck)
    }

    func checkTilesAndDestroy(inout tilesToCheck: [Tile]) {

        if tilesToCheck.count == 0 { return }

        let firstTileToCheck = tilesToCheck.removeAtIndex(0)

        let tilesToDestroy: [Tile] = self.getNeighbours(firstTileToCheck)

        if tilesToDestroy.count >= 3 {

            let tileType: TileType = firstTileToCheck.type

            currentTargets[tileType]! += tilesToDestroy.count

            if currentTargets[tileType]! < levelInfo.colorTargets[tileType]! {
                colorLabels[tileType]!.text = "\(currentTargets[tileType]!)/\(levelInfo.colorTargets[tileType]!)"
            } else if currentTargets[tileType]! > levelInfo.colorTargets[tileType]! {
                colorLabels[tileType]!.text = "FAIL"
                gameOver()
            } else {
                colorLabels[tileType]!.text = "DONE"
            }

            for tile in tilesToDestroy {
                tiles[tile.place.row][tile.place.column] = nil

                if let childTile = tile.childTile {

                    childTile.removeFromParent()
                    self.addChild(childTile)
                    childTile.position = tile.position

                    if childTile.type != TileType.Star {

                        tiles[tile.place.row][tile.place.column] = childTile
                        childTile.zPosition = -2
                        childTile.runAction(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.15), SKAction.scaleTo(1, duration: 0.2)]))

                        tilesToCheck.append(childTile)
                    } else {

                        currentStars[tile.type] = true
                        addStar(childTile, forColor: tile.type)
                    }

                    tile.childTile = nil
                }

                tile.runAction(SKAction.scaleTo(0, duration: 0.1)) {
                    tile.removeFromParent()
                }
            }
        }

        if tilesToCheck.count != 0 {
            self.runAction(SKAction.waitForDuration(0.1)) { [unowned self] in
                self.checkTilesAndDestroy(&tilesToCheck)
            }
        }
    }

    func addStar(tile: Tile, forColor: TileType) {

        let scenePosition = scene!.convertPoint(tile.position, toNode: self)
        let headerPosition = scene!.convertPoint(scenePosition, toNode: topTileNodes[forColor]!)
        tile.position = headerPosition

        tile.removeFromParent()
        tile.zPosition = 3
        topTileNodes[forColor]!.addChild(tile)

        let finalPosition = CGPointZero

        let moveAction = SKAction.moveTo(finalPosition, duration: 0.2)
        let scaleAction = SKAction.sequence([SKAction.scaleTo(1, duration: 0.1), SKAction.scaleTo(2/6, duration: 0.1)])
        let rotateAction = SKAction.rotateByAngle(degree2radian(-15), duration: 0.2)

        let tileMoveAction = SKAction.group([moveAction, scaleAction, rotateAction])

        moveAction.timingMode = SKActionTimingMode.EaseInEaseOut

        tile.runAction(tileMoveAction)
    }

    func getNeighbours(startTile: Tile) -> Array<Tile> {

        var neighbours = Array<Tile>()
        var lastTiles = Array<Tile>()
        var visited = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: false))

        lastTiles.append(startTile)

        while lastTiles.count > 0 {

            var nextTiles = Array<Tile>()

            for tile in lastTiles {
                if !visited[tile.place.row][tile.place.column] && tile.type == startTile.type {
                    visited[tile.place.row][tile.place.column] = true
                    neighbours.append(tile)

                    if tile.place.row - 1 >= 0 {
                        if let neighbour = tiles[tile.place.row - 1][tile.place.column] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.row + 1 < GameScene.boardSize {
                        if let neighbour = tiles[tile.place.row + 1][tile.place.column] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.column - 1 >= 0 {
                        if let neighbour = tiles[tile.place.row][tile.place.column - 1] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.column + 1 < GameScene.boardSize {
                        if let neighbour = tiles[tile.place.row][tile.place.column + 1] {
                            nextTiles.append(neighbour)
                        }
                    }
                }
            }

            lastTiles.removeAll(keepCapacity: true)
            lastTiles += nextTiles
            nextTiles.removeAll(keepCapacity: true)
        }

        return neighbours
    }

    func calculateLimits(tile: Tile) {

        // set all limits to current position
        for (key, _) in limits {
            limits[key] = tile.place
        }

        // right check
        for var i = tile.place.column + 1; i < GameScene.boardSize; ++i {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Right] = (tile.place.row, i)
        }

        // up check
        for var i = tile.place.row - 1; i >= 0; --i {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Up] = (i, tile.place.column)
        }

        // left check
        for var i = tile.place.column - 1; i >= 0; --i {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Left] = (tile.place.row, i)
        }

        // down check
        for var i = tile.place.row + 1; i < GameScene.boardSize; ++i {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Down] = (i, tile.place.column)
        }

//        for (key, value) in limits {
//            debugPrint("\(key) \(value)")
//        }
    }

    func getDirections(delta: CGPoint) {

        if max(fabs(delta.x), fabs(delta.y)) > 0 {
            if fabs(delta.x) > fabs(delta.y) {
                if delta.x > 0.0 {
                    fromDirection = Direction.Left
                    toDirection = Direction.Right
                } else {
                    fromDirection = Direction.Right
                    toDirection = Direction.Left
                }
            } else {
                if delta.y > 0.0 {
                    fromDirection = Direction.Down
                    toDirection = Direction.Up
                } else {
                    fromDirection = Direction.Up
                    toDirection = Direction.Down
                }
            }
            currentDirection = toDirection
        }
    }
    
    func getPlacePosition(place: (row: Int, column: Int)) -> CGPoint {
        return GameScene.boardPositions[place.row][place.column]
    }

    // MARK: Methods - Game

    func prepareGame() {

        for (key, value) in currentTargets {
            colorLabels[key]!.text = "\(value)/\(levelInfo.colorTargets[key]!)"
        }

        var endInterval: NSTimeInterval = -1

        if levelInfo.type == LevelType.LimitedMoves {
            headerBottomLabel.text = "MOVES"
            headerTopLabel.text = "\(levelInfo.typeCounter)"
        }

        if levelInfo.type == LevelType.LimitedTime {
            headerBottomLabel.text = "SECONDS"
            headerTopLabel.text = "\(levelInfo.typeCounter)"
            endInterval = NSTimeInterval(levelInfo.typeCounter)
        }

        if levelInfo.type == LevelType.FreeTime {
            headerBottomLabel.text = "LEVEL"
            headerTopLabel.text = "\(levelInfo.levelNumber)"
        }

        counter = Counter(loopInterval: 1.0, endInterval: endInterval, loopCallback: counterLoop, endCallback: counterEnd)
    }

    func startGame() {
        counter.start()
        moves = 0
    }

    func gameOver() {
        toogleMenu()
    }

    func nextLevel() {

    }

    // MARK: Methods - Counter closures

    func counterLoop(value: NSTimeInterval) {

        if levelInfo.type == LevelType.LimitedTime {
            headerTopLabel.text = "\(levelInfo.typeCounter - Int(value))"
        }

    }

    func counterEnd() {
        if levelInfo.type == LevelType.LimitedTime {
            gameOver()
        }
    }

    // MARK: Methods - Buttons actions

    func showAd() {

    }

    func restartLevel() {

    }

    func share() {

    }

    func goToLobby() {
        parentController!.dismissViewControllerAnimated(true) { [unowned self] in
            self.menu = nil
            self.overlay = nil
            self.counter.destroy()
        }
    }

    func toogleMenu() {

        if menuIsClosed {

            if overlay.parent == nil && menu.parent == nil {
                menuIsClosed = false

                addChild(overlay)
                addChild(menu)
                overlay.runAction(SKAction.fadeAlphaTo(0.75, duration: 0.3))
                menu.runAction(SKAction.fadeInWithDuration(0.3))
            }
        } else {
            menuIsClosed = true

            menu.runAction(SKAction.fadeOutWithDuration(0.3), completion: { [unowned self] in
                self.menu.removeFromParent()
                })

            overlay.runAction(SKAction.fadeOutWithDuration(0.3), completion: { [unowned self] in
                self.overlay.removeFromParent()
                })
        }
    }

    // MARK: Methods - Create Methods

    func createBoard() {

        for i in 0 ... 5 {

            var tilesLine: [Tile?] = []

            for j in 0 ... 5 {

                var tile: Tile? = nil

                if levelInfo.mainTiles[i][j] == TileType.Hole {

                    let holeTile = Tile(row: i, column: j, tileType: TileType.Hole)

                    holeTile.position = GameScene.boardPositions[i][j]
                    holeTile.zPosition = -2

                    tile = holeTile

                    addChild(holeTile)

                } else {

                    if levelInfo.mainTiles[i][j] != TileType.Empty {

                        // create tile

                        let mainTile: Tile = Tile(row: i, column: j, tileType: levelInfo.mainTiles[i][j])

                        mainTile.zPosition = -2
                        mainTile.position = GameScene.boardPositions[i][j]

                        if levelInfo.childTiles[i][j] != TileType.Empty {

                            // create child tile

                            let childTile: Tile = Tile(row: i, column: j, tileType: levelInfo.childTiles[i][j])
                            mainTile.childTile = childTile

                        }

                        tile = mainTile

                        addChild(mainTile)

                    }

                    let backTile = SKSpriteNode(
                        texture: GameScene.tileTexture,
                        color: Constants.tileBackgroundColor,
                        size: Tile.tileSize)

                    backTile.position = GameScene.boardPositions[i][j]
                    backTile.colorBlendFactor = 1
                    backTile.zPosition = -3
                    addChild(backTile)

                }

                tilesLine.append(tile)
            }

            tiles.append(tilesLine)
        }
    }

    func createOverlay() {

        overlay = SKSpriteNode(color: Constants.darkColor, size: size);
        overlay.anchorPoint = CGPointZero
        overlay.zPosition = 0
        overlay.name = "overlay"
        overlay.alpha = 0
    }

    func createMenu() {

        // menu background

        let menuBackgroundSize = CGSizeMake(
            GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x,
            GameScene.boardPositions[1][0].y - GameScene.boardPositions[5][0].y)

        let menuBackground = SKSpriteNode(
            texture: GameScene.menuBackgroundTexture,
            color: Constants.menuBackgroundColor,
            size: menuBackgroundSize)

        menuBackground.colorBlendFactor = 1.0
        menuBackground.anchorPoint = CGPointZero
        menuBackground.position = GameScene.boardPositions[5][0]
        menuBackground.zPosition = 1

        // add buttons

        let buttonMargin = Tile.tileSize.width / 4
        let buttonHeight = (menuBackgroundSize.height - buttonMargin * 4) / 3
        let buttonWidth = (menuBackgroundSize.width - buttonMargin * 4) / 3

        let buttonSize: CGSize = CGSize(width: buttonWidth, height: buttonHeight)

        menuLeftButton = SKSpriteNode(texture: GameScene.menuLeftButtonTexture, color: Constants.menuButtonColor, size: buttonSize)
        menuMiddleButton = SKSpriteNode(texture: GameScene.menuMiddleButtonTexture, color: Constants.menuButtonColor, size: buttonSize)
        menuRightButton = SKSpriteNode(texture: GameScene.menuRightButtonTexture, color: Constants.menuButtonColor, size: buttonSize)

        menuLeftButton.zPosition = 2
        menuMiddleButton.zPosition = 2
        menuRightButton.zPosition = 2

        menuLeftButton.colorBlendFactor = 1.0
        menuMiddleButton.colorBlendFactor = 1.0
        menuRightButton.colorBlendFactor = 1.0

        menuLeftButton.name = ButtonType.Lobby.rawValue
        menuMiddleButton.name = ButtonType.Continue.rawValue
        menuRightButton.name = ButtonType.Restart.rawValue

        menuLeftButton.anchorPoint = CGPointZero
        menuMiddleButton.anchorPoint = CGPointZero
        menuRightButton.anchorPoint = CGPointZero

        menuLeftButton.position.y += buttonMargin
        menuMiddleButton.position.y += buttonMargin
        menuRightButton.position.y += buttonMargin

        menuLeftButton.position.x += buttonMargin
        menuMiddleButton.position.x += buttonMargin * 2 + buttonWidth
        menuRightButton.position.x += buttonMargin * 3 + buttonWidth * 2

        // add top button

        let topButtonSize: CGSize = CGSize(width: menuBackgroundSize.width - buttonMargin * 2, height: buttonHeight)

        menuTopButton = SKSpriteNode(texture: GameScene.menuTopButtonTexture, color: Constants.menuButtonColor, size: topButtonSize)

        menuTopButton.colorBlendFactor = 1.0
        menuTopButton.zPosition = 2
        menuTopButton.anchorPoint = CGPointZero
        menuTopButton.position.x += buttonMargin
        menuTopButton.position.y = buttonHeight * 2 + buttonMargin * 3
        menuTopButton.name = ButtonType.Ad.rawValue

        // add top label

        let topLabel = SKLabelNode()
        topLabel.fontName = Constants.primaryFont
        topLabel.fontColor = Constants.textColor
        topLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        topLabel.position.x = menuTopButton.size.width / 2
        topLabel.position.y = menuTopButton.size.height / 2
        topLabel.name = ButtonType.Ad.rawValue
        topLabel.zPosition = 3

        topLabel.text = "Winer!!!"
        topLabel.fontSize *= min(menuTopButton.frame.height / 2 / topLabel.frame.height, menuTopButton.frame.width / topLabel.frame.width)

        menuTopButton.addChild(topLabel)

        // add middle label

        let middleLabel = SKLabelNode()
        middleLabel.fontName = Constants.primaryFont
        middleLabel.fontColor = Constants.textColor
        middleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        middleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        middleLabel.position.x = menuBackgroundSize.width / 2
        middleLabel.position.y = menuBackgroundSize.height / 2
        middleLabel.zPosition = 3

        middleLabel.text = "LEVEL 42"
        middleLabel.fontSize *= min(topButtonSize.height / 2 / middleLabel.frame.height, topButtonSize.width / middleLabel.frame.width)

        menuBackground.addChild(middleLabel)

        menuBackground.addChild(menuLeftButton)
        menuBackground.addChild(menuMiddleButton)
        menuBackground.addChild(menuRightButton)
        menuBackground.addChild(menuTopButton)

        menu = menuBackground

        menu.alpha = 0
    }

    func createHeader() {

        let headerBackground = SKSpriteNode(
            texture: GameScene.headerBackgroundTexture,
            color: Constants.navigationBackgroundColor,
            size: CGSizeMake(Constants.screenSize.width, Tile.tileLength))

        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        headerBackground.position = CGPoint(x: 0, y: Constants.screenSize.height - Tile.tileLength)
        headerBackground.zPosition = 1

        let leftIcon = SKSpriteNode(
            texture: GameScene.headerLeftCornerTexture,
            color: Constants.navigationButtonColor,
            size: Tile.tileSize)

        leftIcon.position = CGPoint(x: Tile.tileLength / 2, y: Tile.tileLength / 2)
        leftIcon.colorBlendFactor = 1.0
        leftIcon.zPosition = 2
        headerBackground.addChild(leftIcon)

        // add labels to left icon

        let tileTwoThirds = Tile.tileLength / 3 * 2

        headerBottomLabel.fontColor = Constants.textColor
        headerBottomLabel.fontName = Constants.secondaryFont
        headerBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        headerBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerBottomLabel.zPosition = 3
        headerBottomLabel.text = "SECONDS"
        headerBottomLabel.fontSize *= tileTwoThirds / headerBottomLabel.frame.width

        headerTopLabel.fontColor = Constants.textColor
        headerTopLabel.fontName = Constants.primaryFont
        headerTopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        headerTopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerTopLabel.zPosition = 3
        headerTopLabel.text = "999"

        let heightWithoutBottom = tileTwoThirds - headerBottomLabel.frame.height
        let aspectRatio = min(tileTwoThirds / headerTopLabel.frame.width , heightWithoutBottom / headerTopLabel.frame.height)
        headerTopLabel.fontSize *= aspectRatio

        let labelsHeight: CGFloat = headerTopLabel.frame.height + headerBottomLabel.frame.height
        let labelsMargin: CGFloat = (Tile.tileLength - labelsHeight) / 2

        let currentBottomMargin: CGFloat = Tile.tileLength / 2 - headerBottomLabel.frame.height
        let marginsDiff = currentBottomMargin - labelsMargin

        headerBottomLabel.position.y -= marginsDiff
        headerTopLabel.position.y -= marginsDiff

        leftIcon.addChild(headerTopLabel)
        leftIcon.addChild(headerBottomLabel)

        // add right icon
        let rightIcon = SKSpriteNode(
            texture: GameScene.headerRightCornerTexture,
            color: Constants.navigationButtonColor,
            size: Tile.tileSize)

        rightIcon.colorBlendFactor = 1.0
        rightIcon.zPosition = 2

        let pause = SKSpriteNode(texture: SKTexture(imageNamed: "Pause"), color: Constants.textColor, size: Tile.tileSize / 2)
        pause.colorBlendFactor = 1.0
        pause.name = ButtonType.Pause.rawValue
        pause.zPosition = 3

        rightIcon.addChild(pause)
        rightIcon.position = CGPointMake(Constants.screenSize.width - Tile.tileLength / 2, Tile.tileLength / 2)
        rightIcon.name = ButtonType.Pause.rawValue
        headerBackground.addChild(rightIcon)

        var colorsCount = 0
        for (_, value) in levelInfo.colorTargets where value != 0 { ++colorsCount }

        let smallTileWidth = Tile.tileLength / 2
        let widthWithoutLR = Constants.screenSize.width - Tile.tileLength * 2
        let yMiddle = Tile.tileLength / 2
        let space = (widthWithoutLR - 5 * smallTileWidth) / 6
        let actualTilesWidth = CGFloat(colorsCount) * smallTileWidth + CGFloat(colorsCount - 1) * space
        let diffWidth = Constants.screenSize.width - actualTilesWidth

        let startX = diffWidth / 2 + smallTileWidth / 2

        var i = 0
        for (key, value) in levelInfo.colorTargets where value != 0 {
            let x = startX + CGFloat(i) * (space + smallTileWidth)
            headerPositions[key] = CGPointMake(x, yMiddle)
            currentTargets[key] = 0
            currentStars[key] = false
            ++i
        }

        for (key, value) in headerPositions {

            // add top tiles

            let tile = SKSpriteNode(
                texture: GameScene.tileTexture,
                color: key.tileColor,
                size: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2))

            tile.zPosition = 1
            tile.colorBlendFactor = 1.0
            tile.position = value
            tile.position.y += Tile.tileLength / 8
            tile.zPosition = 2

            topTileNodes[key] = tile
            headerBackground.addChild(tile)

            let star = SKSpriteNode(
                texture: GameScene.starTexture,
                color: Constants.navigationBackgroundColor,
                size: CGSizeMake(Tile.tileLength / 3, Tile.tileLength / 3))
            
            star.colorBlendFactor = 1.0
            star.zRotation = degree2radian(-15)
            star.zPosition = 3
            
            tile.addChild(star)
            
            // add labels
            let label = SKLabelNode()
            label.fontColor = Constants.textColor
            label.fontName = Constants.secondaryFont
            label.text = "99/99"
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            label.fontSize *= Tile.tileLength / 8 * 1.5 / label.frame.height
            label.position = value
            label.position.y -= Tile.tileLength / 8 * 2.5
            label.zPosition = 2
            
            colorLabels[key] = label
            headerBackground.addChild(label)
        }
        
        addChild(headerBackground)
    }

    static func createTextures(view: SKView) {

        if GameScene.texturesAreCreated { return }

        debugPrint("generating textures")

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
        
        GameScene.texturesAreCreated = true
    }
}