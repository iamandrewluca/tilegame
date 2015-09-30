//
//  GameScene.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene, TileDragDelegate {

    // MARK: Members - Parent Controller

    weak var parentController: GameViewController!

    // MARK: Members - Game Info

    var levelsInfo: LevelsInfo = LevelsInfo.sharedInstance
    var levelInfo: LevelInfo!
    var level: (section: Int, number: Int)!

    // MARK: Members - Header

    var headerPositions: [TileType:CGPoint] = [:]

    var topSmallTiles: [TileType:SKSpriteNode] = [:]
    var topSmallStars: [TileType:SKSpriteNode!] = [:]
    var colorLabels: [TileType:SKLabelNode] = [:]

    var headerBackground: SKSpriteNode!
    var headerTopLabel: SKLabelNode!
    var headerBottomLabel: SKLabelNode!
    var headerLeftIcon: SKSpriteNode!

    var pauseIcon: SKSpriteNode!
    var pauseButton: SKSpriteNode!

    // MARK: Members - Overlay

    var overlay: SKSpriteNode!

    // MARK: Members - Menu

    var menu: SKSpriteNode!

    var menuLeftButton: SKSpriteNode!
    var menuMiddleButton: SKSpriteNode!
    var menuRightButton: SKSpriteNode!

    var menuRestartIcon: SKSpriteNode!
    var menuShareIcon: SKSpriteNode!
    var menuPauseIcon: SKSpriteNode!
    var menuNextIcon: SKSpriteNode!

    var menuTopButton: SKSpriteNode!
    var menuTopButtonLabel: SKLabelNode!
    var menuMiddleLabel: SKLabelNode!

    // MARK: Members - Board

    let tilesAppearInterval: NSTimeInterval = 0.5
    let tilesDissappearInterval: NSTimeInterval = 0.2
    let menuToogleInterval: NSTimeInterval = 0.1

    static let boardSize: Int = 6
    static let boardPositions: [[CGPoint]] = { () -> [[CGPoint]] in

        let boardHorizontalMargin = (Constants.screenSize.width - 6 * Tile.tileLength - 5 * Tile.tileSpacing) / 2
        let boardVerticalMargin = (Constants.screenSize.height - Constants.screenSize.width) / 2 +
            boardHorizontalMargin + Tile.tileLength / 2

        var board = Array(count: boardSize,
            repeatedValue: Array(count: boardSize,
                repeatedValue: CGPoint.zero))

        for i in 0 ..< boardSize {
            for j in 0 ..< boardSize {
                board[i][j] = CGPoint(
                    x: boardHorizontalMargin + Tile.tileLength / 2 + CGFloat(j) * (Tile.tileSpacing + Tile.tileLength),
                    y: boardVerticalMargin + CGFloat(boardSize - 1 - i) * (Tile.tileSpacing + Tile.tileLength))
            }
        }

        return board
        }()

    var tiles: [[Tile?]] = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))

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
    var gameIsPaused: Bool = false
    var canSwipe: Bool = false
    var canTouch: Bool = false

    var currentSwipedTile: Tile?
    var currentTouchedButtonName: String = ""

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

        addBoardBackgroundAndHoles()

        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: "didEnterBackground", name: UIApplicationWillResignActiveNotification, object: nil)

        // tiles are added in viewDidAppear
    }

    // MARK: Methods - View actions

    func viewDidAppear() {
        addBoardTiles()

        // show tutorial here for some levels
    }

    // MARK: Override - UIResponder

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)

        if !canTouch { return }

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        print("began on \(node.name)")
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)

        if !canTouch { return }

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        print("move on \(node.name)")
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)

        if !canTouch { return }

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        print("ended on \(node.name)")

        if node.name == ButtonType.Overlay.rawValue {
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
            restartGame()
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
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)

        print("canceled")
    }

    // MARK: Methods - Tile Drag Protocol

    func tileDragBegan(tile: Tile, position: CGPoint) {

        if !canSwipe { return }

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
    func tileDragMoved(tile: Tile, position: CGPoint) {

        if !canSwipe { return }

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
    func tileDragEnded(tile: Tile, position: CGPoint) {

        if !canSwipe { return }

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
    func tileDragCancelled(tile: Tile, position: CGPoint) {
        tileDragEnded(tile, position: position)
    }

    // MARK: Methods - Tile Methods

    func tileWasMoved(tile: Tile) {

        var isGameOver: Bool = false

        moves++

        if levelInfo.type == LevelType.LimitedMoves {

            let leftMoves = levelInfo.typeCounter - moves
            headerTopLabel.text = "\(leftMoves)"

            if leftMoves == 1 {
                headerBottomLabel.text = "MOVE"
            } else {
                headerBottomLabel.text = "MOVES"
            }

            if moves >= levelInfo.typeCounter {
                isGameOver = true
            }
        }

        var tilesToCheck: [Tile] = [tile]
        checkTilesAndDestroy(&tilesToCheck)

        if isLevelDone() {
            gameWon()
        } else {
            if isGameOver {
                gameOver()
            }
        }
    }

    func isLevelDone() -> Bool {
        return false
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

                    tile.childTile = nil

                    childTile.removeFromParent()
                    childTile.position = tile.position
                    childTile.zPosition = 2
                    addChild(childTile)

                    if childTile.type != TileType.Star {

                        tiles[tile.place.row][tile.place.column] = childTile
                        childTile.runAction(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.15), SKAction.scaleTo(1, duration: 0.2)]))
                        childTile.userInteractionEnabled = true

                        tilesToCheck.append(childTile)
                    } else {
                        addStar(childTile, forColor: tile.type)
                    }
                }

                tile.runAction(SKAction.scaleTo(0, duration: tilesDissappearInterval)) {
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

        currentStars[forColor] = true

        let scenePosition = scene!.convertPoint(tile.position, toNode: self)
        let headerPosition = scene!.convertPoint(scenePosition, toNode: topSmallTiles[forColor]!)
        tile.position = headerPosition

        tile.removeFromParent()
        tile.zPosition = 3
        topSmallTiles[forColor]!.addChild(tile)
        topSmallStars[forColor] = tile

        let finalPosition = CGPointZero

        let moveAction = SKAction.moveTo(finalPosition, duration: 0.4)
        let scaleAction = SKAction.sequence([SKAction.scaleTo(1, duration: 0.2), SKAction.scaleTo(2/6, duration: 0.2)])
        let rotateAction = SKAction.rotateByAngle(degree2radian(-15), duration: 0.4)

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

    func startGame() {
        counter.start()
    }

    func gameOver() {
        prepareButtonsForLose()
        toogleMenu()
    }

    func gameWon() {

    }

    func nextLevel() {

//        changeLevelWith(nextLevel)

    }

    func changeLevelWith(level: LevelInfo) {

        self.canTouch = false
        self.canSwipe = false

        for i in 0 ..< 6 {
            for j in 0 ..< 6 {

                if let tile = tiles[i][j] {
                    tiles[i][j] = nil
                    tile.runAction(SKAction.scaleTo(0, duration: tilesDissappearInterval)) {
                        tile.removeFromParent()
                    }
                }
            }
        }

        self.runAction(SKAction.waitForDuration(tilesDissappearInterval + 0.2)) { [unowned self] in
            self.addBoardTiles()
        }
    }

    func resetTargetsTo(levelInfo: LevelInfo) {

        for (key, _) in headerPositions {
            topSmallTiles[key]!.removeFromParent()
            colorLabels[key]!.removeFromParent()
        }

        topSmallTiles.removeAll(keepCapacity: false)
        colorLabels.removeAll(keepCapacity: false)
        headerPositions.removeAll(keepCapacity: false)
        currentTargets.removeAll(keepCapacity: false)
        currentStars.removeAll(keepCapacity: false)

        for (_, value) in topSmallStars {
            value.removeFromParent()
        }

        topSmallStars.removeAll(keepCapacity: false)

        moves = 0

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

        if let counter = self.counter {
            counter.stop()
        } else {
            counter = Counter(loopInterval: 1.0, endInterval: endInterval, loopCallback: counterLoop, endCallback: counterEnd)
        }

        var colorsCount: Int = 0
        for (key, value) in levelInfo.colorTargets where value != 0 {
            colorsCount++
            currentTargets[key] = 0
        }

        let smallTileWidth = Tile.tileLength / 2
        let widthWithoutLeftRightButtons = Constants.screenSize.width - Tile.tileLength * 2
        let yMiddle = Tile.tileLength / 2
        let space = (widthWithoutLeftRightButtons - 5 * smallTileWidth) / 6
        let actualTilesWidth = CGFloat(colorsCount) * smallTileWidth + CGFloat(colorsCount - 1) * space
        let diffWidth = Constants.screenSize.width - actualTilesWidth

        let startX = diffWidth / 2 + smallTileWidth / 2

        var i = 0
        for (key, _) in currentTargets {
            let x = startX + CGFloat(i) * (space + smallTileWidth)
            headerPositions[key] = CGPointMake(x, yMiddle)
            ++i
        }

        for (key, value) in headerPositions {

            // add top tiles

            let tile = SKSpriteNode(texture: Textures.tileTexture,
                color: key.tileColor,
                size: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2))

            tile.zPosition = 1
            tile.colorBlendFactor = 1.0
            tile.position = value
            tile.position.y += Tile.tileLength / 8
            tile.zPosition = 1

            topSmallTiles[key] = tile
            headerBackground.addChild(tile)

            if levelInfo.starTargets[key] != false {
                let star = SKSpriteNode(texture: Textures.starTexture,
                    color: Constants.navigationBackgroundColor,
                    size: CGSizeMake(Tile.tileLength / 3, Tile.tileLength / 3))

                star.colorBlendFactor = 1.0
                star.zRotation = degree2radian(-15)
                star.zPosition = 1

                topSmallStars[key] = star
                tile.addChild(star)
                currentStars[key] = false
            }

            // add labels
            let label = SKLabelNode()
            label.fontColor = Constants.textColor
            label.fontName = Constants.secondaryFont
            label.text = "00/00"
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center

            let labelSizeRatio: CGFloat = Tile.tileLength / 8 * 1.5 / label.frame.height
            label.fontSize *= labelSizeRatio
            label.position = value
            label.position.y -= Tile.tileLength / 8 * 2.5
            label.zPosition = 1
            
            colorLabels[key] = label
            colorLabels[key]!.text = "\(0)/\(levelInfo.colorTargets[key]!)"

            headerBackground.addChild(label)
        }
    }

    func pauseGame() {
        if gameIsStarted { counter.pause() }
    }

    func resumeGame() {
        if gameIsStarted { counter.start() }
    }

    func restartGame() {
        gameIsStarted = false
        resetTargetsTo(levelInfo)
        changeLevelWith(levelInfo)
        prepareButtonsForPause()
        toogleMenu()
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
            toogleMenuOn(true)
            pauseGame()
        } else {
            toogleMenuOff()
            resumeGame()
        }
    }

    func toogleMenuOn(animated: Bool) {
        if overlay.parent == nil && menu.parent == nil {

            menuIsClosed = false
            addChild(overlay)
            addChild(menu)

            if animated {
                overlay.runAction(SKAction.fadeAlphaTo(0.75, duration: 0.3))
                menu.runAction(SKAction.fadeInWithDuration(0.3))
            } else {
                overlay.alpha = 0.75
                menu.alpha = 1
            }
        }
    }

    func toogleMenuOff() {
        if overlay.parent != nil && menu.parent != nil {

            menuIsClosed = true

            menu.runAction(SKAction.fadeOutWithDuration(0.3)) { [unowned self] in
                self.menu.removeFromParent()
            }

            overlay.runAction(SKAction.fadeOutWithDuration(0.3)) { [unowned self] in
                self.overlay.removeFromParent()
            }
        }
    }

    func didEnterBackground() {
        pauseGame()
        toogleMenuOn(false)
    }

    // MARK: Methods - Buttons game states changing

    func prepareButtonsForWin() {

        menuMiddleButton.name = ButtonType.Next.rawValue
        menuRightButton.name = ButtonType.Restart.rawValue

        pauseButton.name = ButtonType.Empty.rawValue
        pauseIcon.name = ButtonType.Empty.rawValue
        overlay.name = ButtonType.Empty.rawValue

        menuNextIcon.removeFromParent()
        menuMiddleButton.removeAllChildren()
        menuMiddleButton.addChild(menuNextIcon)

        menuRestartIcon.removeFromParent()
        menuRightButton.removeAllChildren()
        menuRightButton.addChild(menuRestartIcon)

    }

    func prepareButtonsForLose() {

        menuMiddleButton.name = ButtonType.Restart.rawValue
        menuRightButton.name = ButtonType.Share.rawValue

        pauseButton.name = ButtonType.Empty.rawValue
        pauseIcon.name = ButtonType.Empty.rawValue
        overlay.name = ButtonType.Empty.rawValue

        menuRestartIcon.removeFromParent()
        menuMiddleButton.removeAllChildren()
        menuMiddleButton.addChild(menuRestartIcon)

        menuShareIcon.removeFromParent()
        menuRightButton.removeAllChildren()
        menuRightButton.addChild(menuShareIcon)

    }

    func prepareButtonsForPause() {

        menuMiddleButton.name = ButtonType.Continue.rawValue
        menuRightButton.name = ButtonType.Restart.rawValue

        pauseButton.name = ButtonType.Pause.rawValue
        pauseIcon.name = ButtonType.Pause.rawValue
        overlay.name = ButtonType.Overlay.rawValue

        menuPauseIcon.removeFromParent()
        menuMiddleButton.removeAllChildren()
        menuMiddleButton.addChild(menuPauseIcon)

        menuRestartIcon.removeFromParent()
        menuRightButton.removeAllChildren()
        menuRightButton.addChild(menuRestartIcon)

    }

    // MARK: Methods - Create Methods

    func addBoardTiles() {

        canSwipe = false
        canTouch = false

        for i in 0 ... 5 {
            for j in 0 ... 5 {
                if levelInfo.mainTiles[i][j] != TileType.Hole &&
                    levelInfo.mainTiles[i][j] != TileType.Empty {
                        addTile(i, column: j)
                }
            }
        }

        self.runAction(SKAction.waitForDuration(tilesAppearInterval + 0.2)) { [unowned self] in
            self.canTouch = true
            self.canSwipe = true
        }
    }

    func addTile(row: Int, column: Int) {
        let mainTile: Tile = Tile(row: row, column: column, tileType: levelInfo.mainTiles[row][column], delegate: self)
        mainTile.zPosition = 2
        mainTile.position = GameScene.boardPositions[row][column]

        if levelInfo.childTiles[row][column] != TileType.Empty {
            let childTile: Tile = Tile(row: row, column: column, tileType: levelInfo.childTiles[row][column], delegate: self)
            childTile.zPosition = 1
            mainTile.childTile = childTile
        }

        tiles[row][column] = mainTile

        mainTile.setScale(0)

        addChild(mainTile)

        mainTile.runAction(SKAction.scaleTo(1, duration: tilesAppearInterval))
    }

    func addBoardBackgroundAndHoles() {
        for i in 0 ... 5 {
            for j in 0 ... 5 {
                if levelInfo.mainTiles[i][j] == TileType.Hole {
                    tiles[i][j] = addBoardHole(i, column: j)
                } else {
                    addBoardBackgroundTile(i, column: j)
                }
            }
        }
    }

    func addBoardHole(row: Int, column: Int) -> Tile {
        let holeTile = Tile(row: row, column: column, tileType: TileType.Hole, delegate: self)
        holeTile.position = GameScene.boardPositions[row][column]
//        once caused collision avoid
//        holeTile.hidden = true
        addChild(holeTile)
        return holeTile
    }

    func addBoardBackgroundTile(row: Int, column: Int) {
        let backTile = SKSpriteNode(texture: Textures.tileTexture, color: Constants.tileBackgroundColor, size: Tile.tileSize)
        backTile.position = GameScene.boardPositions[row][column]
        backTile.colorBlendFactor = 1
        backTile.zPosition = 1
        addChild(backTile)
    }

    func createOverlay() {
        overlay = SKSpriteNode(color: Constants.darkColor, size: size);
        overlay.anchorPoint = CGPointZero
        overlay.zPosition = 4
        overlay.name = ButtonType.Overlay.rawValue
        overlay.alpha = 0
    }

    func createMenu() {

        // menu background

        let menuBackgroundWidth: CGFloat = GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x
        let menuBackgroundHeight: CGFloat = GameScene.boardPositions[1][0].y - GameScene.boardPositions[5][0].y
        let menuBackgroundSize: CGSize = CGSizeMake(menuBackgroundWidth, menuBackgroundHeight)

        let menuBackground: SKSpriteNode = SKSpriteNode(texture: Textures.menuBackgroundTexture,
            color: Constants.menuBackgroundColor, size: menuBackgroundSize)

        menuBackground.colorBlendFactor = 1.0
        menuBackground.anchorPoint = CGPointZero
        menuBackground.position = GameScene.boardPositions[5][0]
        menuBackground.zPosition = 5

        // add buttons

        let buttonMargin: CGFloat = Tile.tileSize.width / 4
        let buttonHeight: CGFloat = (menuBackgroundHeight - buttonMargin * 4) / 3
        let buttonWidth: CGFloat = (menuBackgroundWidth - buttonMargin * 4) / 3
        let topButtonWidth: CGFloat = menuBackgroundWidth - buttonMargin * 2

        let menuButtonsSize: CGSize = CGSize(width: buttonWidth, height: buttonHeight)
        let menuTopButtonsSize: CGSize = CGSize(width: topButtonWidth, height: buttonHeight)

        menuLeftButton = SKSpriteNode(texture: Textures.menuLeftButtonTexture,
            color: Constants.menuButtonColor, size: menuButtonsSize)

        menuMiddleButton = SKSpriteNode(texture: Textures.menuMiddleButtonTexture,
            color: Constants.menuButtonColor, size: menuButtonsSize)

        menuRightButton = SKSpriteNode(texture: Textures.menuRightButtonTexture,
            color: Constants.menuButtonColor, size: menuButtonsSize)

        menuTopButton = SKSpriteNode(texture: Textures.menuTopButtonTexture,
            color: Constants.menuButtonColor, size: menuTopButtonsSize)

        menuLeftButton.zPosition = 1
        menuMiddleButton.zPosition = 1
        menuRightButton.zPosition = 1
        menuTopButton.zPosition = 1

        menuLeftButton.colorBlendFactor = 1.0
        menuMiddleButton.colorBlendFactor = 1.0
        menuRightButton.colorBlendFactor = 1.0
        menuTopButton.colorBlendFactor = 1.0

        menuLeftButton.name = ButtonType.Lobby.rawValue
        menuMiddleButton.name = ButtonType.Continue.rawValue
        menuRightButton.name = ButtonType.Restart.rawValue
        menuTopButton.name = ButtonType.Ad.rawValue

        menuLeftButton.anchorPoint = CGPointZero
        menuMiddleButton.anchorPoint = CGPointZero
        menuRightButton.anchorPoint = CGPointZero
        menuTopButton.anchorPoint = CGPointZero

        menuLeftButton.position.y += buttonMargin
        menuMiddleButton.position.y += buttonMargin
        menuRightButton.position.y += buttonMargin
        menuTopButton.position.y = buttonHeight * 2 + buttonMargin * 3

        menuLeftButton.position.x += buttonMargin
        menuMiddleButton.position.x += buttonMargin * 2 + buttonWidth
        menuRightButton.position.x += buttonMargin * 3 + buttonWidth * 2
        menuTopButton.position.x += buttonMargin

        // add menu buttons icons

        let lobbyIcon: SKSpriteNode = SKSpriteNode(imageNamed: "Lobby")
        menuLeftButton.addChild(lobbyIcon)
        lobbyIcon.position = CGPoint(x: buttonWidth / 2, y: buttonHeight / 2)
        lobbyIcon.name = ButtonType.Lobby.rawValue
        lobbyIcon.colorBlendFactor = 1.0
        lobbyIcon.color = Constants.menuBackgroundColor
        lobbyIcon.zPosition = 1

        menuPauseIcon = SKSpriteNode(imageNamed: "Pause")
        menuMiddleButton.addChild(menuPauseIcon)
        menuPauseIcon.position = lobbyIcon.position
        menuPauseIcon.name = ButtonType.Pause.rawValue
        menuPauseIcon.colorBlendFactor = 1.0
        menuPauseIcon.color = Constants.menuBackgroundColor
        menuPauseIcon.zPosition = 1

        menuRestartIcon = SKSpriteNode(imageNamed: "Restart")
        menuRightButton.addChild(menuRestartIcon)
        menuRestartIcon.position = lobbyIcon.position
        menuRestartIcon.name = ButtonType.Restart.rawValue
        menuRestartIcon.colorBlendFactor = 1.0
        menuRestartIcon.color = Constants.menuBackgroundColor
        menuRestartIcon.zPosition = 1

        menuShareIcon = SKSpriteNode(imageNamed: "Share")
        menuShareIcon.position = lobbyIcon.position
        menuShareIcon.name = ButtonType.Share.rawValue
        menuShareIcon.colorBlendFactor = 1.0
        menuShareIcon.color = Constants.menuBackgroundColor
        menuShareIcon.zPosition = 1

        menuNextIcon = SKSpriteNode(imageNamed: "Next")
        menuNextIcon.position = lobbyIcon.position
        menuNextIcon.name = ButtonType.Next.rawValue
        menuNextIcon.colorBlendFactor = 1.0
        menuNextIcon.color = Constants.menuBackgroundColor
        menuNextIcon.zPosition = 1

        // add top label

        menuTopButtonLabel = SKLabelNode()
        menuTopButtonLabel.fontName = Constants.primaryFont
        menuTopButtonLabel.fontColor = Constants.textColor
        menuTopButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        menuTopButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        menuTopButtonLabel.position.x = menuTopButton.size.width / 2
        menuTopButtonLabel.position.y = menuTopButton.size.height / 2
        menuTopButtonLabel.name = ButtonType.Ad.rawValue
        menuTopButtonLabel.zPosition = 1
        menuTopButtonLabel.text = "SAME TEXT HERE AND THERE"

        let menuTopButtonLabelHeightRatio: CGFloat = menuTopButton.frame.height / 2 / menuTopButtonLabel.frame.height
        let menuTopButtonLabelWidthRatio: CGFloat = menuTopButton.frame.width / menuTopButtonLabel.frame.width
        menuTopButtonLabel.fontSize *= min(menuTopButtonLabelHeightRatio, menuTopButtonLabelWidthRatio)

        menuTopButton.addChild(menuTopButtonLabel)

        // add middle label

        menuMiddleLabel = SKLabelNode()
        menuMiddleLabel.fontName = Constants.primaryFont
        menuMiddleLabel.fontColor = Constants.textColor
        menuMiddleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        menuMiddleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        menuMiddleLabel.position.x = menuBackgroundSize.width / 2
        menuMiddleLabel.position.y = menuBackgroundSize.height / 2
        menuMiddleLabel.zPosition = 1
        menuMiddleLabel.text = "SAME TEXT HERE AND THERE"

        let menuMiddleLabelHeightRatio: CGFloat = menuTopButtonsSize.height / 2 / menuMiddleLabel.frame.height
        let menuMiddleLabelWidthRatio: CGFloat = menuTopButtonsSize.width / menuMiddleLabel.frame.width
        menuMiddleLabel.fontSize *= min(menuMiddleLabelHeightRatio, menuMiddleLabelWidthRatio)

        menuBackground.addChild(menuMiddleLabel)
        menuBackground.addChild(menuLeftButton)
        menuBackground.addChild(menuMiddleButton)
        menuBackground.addChild(menuRightButton)
        menuBackground.addChild(menuTopButton)

        menu = menuBackground

        menu.alpha = 0
    }

    func setupHeaderLeftLabels() {

        headerLeftIcon.removeAllChildren()

        let tileTwoThirds = Tile.tileLength / 3 * 2

        headerBottomLabel = SKLabelNode()
        headerBottomLabel.fontColor = Constants.textColor
        headerBottomLabel.fontName = Constants.secondaryFont
        headerBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        headerBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerBottomLabel.zPosition = 1
        headerBottomLabel.setTextWithinSize("SECONDS", size: tileTwoThirds, vertically: false)

        headerTopLabel = SKLabelNode()
        headerTopLabel.fontColor = Constants.textColor
        headerTopLabel.fontName = Constants.secondaryFont
        headerTopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        headerTopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerTopLabel.zPosition = 1
        headerTopLabel.text = "9999"

        let heightWithoutBottomLabel: CGFloat = tileTwoThirds - headerBottomLabel.frame.height
        let headerTopLabelHeightRatio: CGFloat = tileTwoThirds / headerTopLabel.frame.width
        let headerTopLabelWidthRatio: CGFloat = heightWithoutBottomLabel / headerTopLabel.frame.height
        headerTopLabel.fontSize *= min(headerTopLabelHeightRatio, headerTopLabelWidthRatio)

        let labelsHeight: CGFloat = headerTopLabel.frame.height + headerBottomLabel.frame.height
        let labelsMargin: CGFloat = (Tile.tileLength - labelsHeight) / 2
        let currentBottomMargin: CGFloat = Tile.tileLength / 2 - headerBottomLabel.frame.height
        let marginsDiff: CGFloat = currentBottomMargin - labelsMargin

        headerBottomLabel.position.y -= marginsDiff
        headerTopLabel.position.y -= marginsDiff

        headerLeftIcon.addChild(headerTopLabel)
        headerLeftIcon.addChild(headerBottomLabel)
    }

    func createHeader() {

        headerBackground = SKSpriteNode(texture: Textures.headerBackgroundTexture,
            color: Constants.navigationBackgroundColor, size: CGSizeMake(Constants.screenSize.width, Tile.tileLength))

        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        headerBackground.position = CGPoint(x: 0, y: Constants.screenSize.height - Tile.tileLength)
        headerBackground.zPosition = 5

        headerLeftIcon = SKSpriteNode(texture: Textures.headerLeftCornerTexture,
            color: Constants.navigationButtonColor, size: Tile.tileSize)

        headerLeftIcon.position = CGPoint(x: Tile.tileLength / 2, y: Tile.tileLength / 2)
        headerLeftIcon.colorBlendFactor = 1.0
        headerLeftIcon.zPosition = 1
        headerBackground.addChild(headerLeftIcon)

        setupHeaderLeftLabels()

        // add right button

        pauseButton = SKSpriteNode(texture: Textures.headerRightCornerTexture,
            color: Constants.navigationButtonColor, size: Tile.tileSize)
        pauseButton.colorBlendFactor = 1.0
        pauseButton.zPosition = 1
        pauseButton.position = CGPointMake(Constants.screenSize.width - Tile.tileLength / 2, Tile.tileLength / 2)
        pauseButton.name = ButtonType.Pause.rawValue

        // add pause image to button

        pauseIcon = SKSpriteNode(texture: SKTexture(imageNamed: "Pause"),
            color: Constants.textColor, size: Tile.tileSize / 2)
        pauseIcon.colorBlendFactor = 1.0
        pauseIcon.name = ButtonType.Pause.rawValue
        pauseIcon.zPosition = 1

        pauseButton.addChild(pauseIcon)
        headerBackground.addChild(pauseButton)

        resetTargetsTo(levelInfo)
        
        addChild(headerBackground)
    }
}