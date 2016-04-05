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

    weak var gameVC: GameViewController!

    // MARK: Members - Game Info

    var levelsInfo: LevelsInfo = LevelsInfo.sharedInstance
    var levelInfo: LevelInfo!

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
    var menuTopButton: SKSpriteNode!

    var menuTopButtonLabel: SKLabelNode!
    var menuMiddleLabel: SKLabelNode!

    var menuRestartIcon: SKSpriteNode!
    var menuShareIcon: SKSpriteNode!
    var menuPauseIcon: SKSpriteNode!
    var menuNextIcon: SKSpriteNode!

    var touchesBeganOn: String!

    var winStarsShadows: [SKSpriteNode] = []

    // MARK: Animations intervals

    let tilesAppearInterval: NSTimeInterval = 0.4
    let tilesDissappearInterval: NSTimeInterval = 0.2
    let menuToogleInterval: NSTimeInterval = 0.1
    let tileMovingInterval: NSTimeInterval = 0.1
    let overlayAlpha: CGFloat = 0.8

    // MARK: Members - Board

    static let boardSize: Int = 6
    static let boardPositions: [[CGPoint]] = GameScene.createBoardPositions()

    var tiles: [[Tile?]] = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))
    var backgroundTiles: [[SKSpriteNode?]] = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: SKSpriteNode?.None))

    // MARK: Members - Game State

    var limits: [Direction:(row: Int, column: Int)] = [
        Direction.Up: (row: 0, column: 0),
        Direction.Right: (row: 0, column: 0),
        Direction.Down: (row: 0, column: 0),
        Direction.Left: (row: 0, column: 0)
    ]

    var startTouchPoint: CGPoint = CGPointZero
    var lastTouchPoint: CGPoint = CGPointZero
    var startTilePoint: CGPoint = CGPointZero
    var endTilePoint: CGPoint = CGPointZero

    var currentDirection: Direction = Direction.None
    var fromDirection: Direction = Direction.None
    var toDirection: Direction = Direction.None

    var counter: Counter!
    var moves: Int = 0
    var currentTargets: [TileType:Int] = [:]
    var currentStars: [TileType:Bool] = [:]

    var gameIsStarted: Bool = false
    var gameIsPaused: Bool = false
    var canTouch: Bool = false

    var currentSwipedTile: Tile?

    // MARK: Override - SKScene

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        debugPrint("GameScene deinit")
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        /* Setup your scene here */

        backgroundColor = Constants.backgroundColor

        createOverlay()

        createMenu()

        createHeader()

        createWinStarsShadows()

        addBoardBackgroundAndHoles()

        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(GameScene.didEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)

        // tiles are added in viewDidAppear
    }

    // MARK: Methods - View actions

    func viewDidAppear() {
        addBoardTiles()

        // show tutorial here for some levels
    }

    // MARK: Override - UIResponder

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if !canTouch { return }

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        touchesBeganOn = ""
        touchesBeganOn = node.name

//        debugPrint("began on \(node.name)")
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if !canTouch { return }

//        let location = touches.first!.locationInNode(self)
//        let node = nodeAtPoint(location)

//        debugPrint("move on \(node.name)")
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if !canTouch { return }

        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)

        if node.name != touchesBeganOn { return }

//        debugPrint("ended on \(node.name)")

        if node.name == ButtonType.Overlay.rawValue {
            toogleMenuOff(true)
        }

        if node.name == ButtonType.Pause.rawValue {
            toogleMenu(true)
        }

        if node.name == ButtonType.Lobby.rawValue {
            goToLobby()
        }

        if node.name == ButtonType.Continue.rawValue {
            toogleMenuOff(true)
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
        touchesEnded(touches!, withEvent: event)
        debugPrint("canceled")
    }

    // MARK: Methods - Tile Drag Protocol

    func tileDragBegan(tile: Tile, position: CGPoint) {

        if !canTouch { return }

        if currentSwipedTile != nil { return }

        currentSwipedTile = tile

        calculateLimits(tile)

        startTouchPoint = position
        lastTouchPoint = startTouchPoint

        fromDirection = Direction.None
        toDirection = Direction.None
        currentDirection = Direction.None
    }
    func tileDragMoved(tile: Tile, position: CGPoint) {

        if !canTouch { return }

        if currentSwipedTile != tile { return }

        let currentTouchPoint = position

        if toDirection == Direction.None {

            setDirs(startTouchPoint, end: currentTouchPoint)

            startTilePoint = getPlacePosition(tile.place)
            endTilePoint = getPlacePosition(limits[toDirection]!)
        }

        if tile.place == limits[toDirection]! {
            currentSwipedTile = nil
            return
        } else {
            if !gameIsStarted {
                debugPrint("game is started")
                startGame()
                gameIsStarted = true
            }
        }

        currentDirection = getDirFromPointsForceAxis(lastTouchPoint, end: currentTouchPoint, axis: getAxisFromDir(toDirection))
//        debugPrint(currentDirection)

        tile.position.x = clamp(startTilePoint.x, endTilePoint.x, currentTouchPoint.x)
        tile.position.y = clamp(startTilePoint.y, endTilePoint.y, currentTouchPoint.y)

        lastTouchPoint = currentTouchPoint
    }
    func tileDragEnded(tile: Tile, position: CGPoint) {

        if !canTouch { return }

        if currentSwipedTile != tile { return }
        if toDirection == Direction.None { return }

        canTouch = false

        AudioPlayer.swipe()

        if currentDirection == toDirection {
            tile.runAction(SKAction.moveTo(endTilePoint, duration: tileMovingInterval)) { [unowned self] in

                let startPlace = self.currentSwipedTile!.place
                let endPlace = self.limits[self.toDirection]!

                self.tiles[endPlace.row][endPlace.column] = self.currentSwipedTile
                self.tiles[startPlace.row][startPlace.column] = nil
                self.currentSwipedTile!.place = endPlace

                self.tileWasMoved(tile) { [unowned self] in
                    self.checkAndChangeGameState()
                    //                debugPrint("now can touch")
                    self.canTouch = true
                }

                self.currentSwipedTile = nil
                self.fromDirection = Direction.None
                self.toDirection = Direction.None
                self.currentDirection = Direction.None
            }
        } else {
            tile.runAction(SKAction.moveTo(startTilePoint, duration: tileMovingInterval)) { [unowned self] in
                self.canTouch = true
                self.currentSwipedTile = nil
                self.fromDirection = Direction.None
                self.toDirection = Direction.None
                self.currentDirection = Direction.None
            }
        }
    }
    func tileDragCancelled(tile: Tile, position: CGPoint) {
        debugPrint("tile drag canceled")
        tileDragEnded(tile, position: position)
    }

    // MARK: Methods - Tile Methods

    func tileWasMoved(tile: Tile, completion: () -> Void) {

        moves += 1

        var tilesToCheck: [Tile] = [tile]
        checkTilesAndDestroy(&tilesToCheck) {
            completion()
        }

        if levelInfo.type == LevelType.LimitedMoves {
            let leftMoves = levelInfo.typeCounter - moves
            headerTopLabel.text = "\(leftMoves)"
        }
    }

    /**
    Checks tiles for chains and destroy them.
    This method can delay a little depnding on numbers of chains

    - parameter tilesToCheck: tiles to check for neighbours
    - parameter completion:   callback called when all chains are destroyed
    */
    func checkTilesAndDestroy(inout tilesToCheck: [Tile], completion: () -> Void) {

        if tilesToCheck.count == 0 { return }

        let firstTileToCheck: Tile = tilesToCheck.removeAtIndex(0)
        let tileType: TileType = firstTileToCheck.type

        let tilesToDestroy: [Tile] = self.getNeighbours(firstTileToCheck)

        if tilesToDestroy.count >= 3 {

//            debugPrint("\(tilesToDestroy.count) is >= 3")

            currentTargets[tileType]! += tilesToDestroy.count

            if currentTargets[tileType]! < levelInfo.colorTargets[tileType]! {
                colorLabels[tileType]!.text = "\(currentTargets[tileType]!)/\(levelInfo.colorTargets[tileType]!)"
            } else if currentTargets[tileType]! != levelInfo.colorTargets[tileType]!
                    && currentTargets[tileType]! + 3 > levelInfo.colorTargets[tileType]! {
                colorLabels[tileType]!.text = "FAIL"
            } else {
                colorLabels[tileType]!.text = "DONE"
            }

            AudioPlayer.destroy()

            for tile in tilesToDestroy {
                tiles[tile.place.row][tile.place.column] = nil

                if let childTile = tile.childTile {

                    tile.childTile = nil

                    childTile.position = tile.position
                    childTile.zPosition = 2

                    if childTile.type != TileType.Star {

                        childTile.removeFromParent()
                        self.addChild(childTile)

                        tiles[tile.place.row][tile.place.column] = childTile
                        childTile.userInteractionEnabled = true
                        childTile.runAction(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.15), SKAction.scaleTo(1, duration: 0.2)]))

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
//            debugPrint("cycle check tyles to destroy")
            self.runAction(SKAction.waitForDuration(tilesDissappearInterval - 0.1)) { [unowned self] in
                self.checkTilesAndDestroy(&tilesToCheck, completion: completion)
            }
        } else {
            completion()
        }
    }

    func addStar(tile: Tile, forColor: TileType) {

        currentStars[forColor] = true

        let headerPosition = scene!.convertPoint(tile.position, toNode: topSmallTiles[forColor]!)
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
        for i in tile.place.column + 1 ..< GameScene.boardSize {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Right] = (tile.place.row, i)
        }

        // up check

        for i in (0 ..< tile.place.row).reverse() {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Up] = (i, tile.place.column)
        }

        // left check
        for i in (0 ..< tile.place.column).reverse() {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Left] = (tile.place.row, i)
        }

        // down check
        for i in tile.place.row + 1 ..< GameScene.boardSize {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Down] = (i, tile.place.column)
        }
    }

    func getAxisFromDir(dir: Direction) -> Axis {

        if dir == Direction.Left || dir == Direction.Right {
            return Axis.Horizontal
        }

        if dir == Direction.Up || dir == Direction.Down {
            return Axis.Vertical
        }

        return Axis.None
    }

    func getDirFromPointsWithErrorForceAxis(start: CGPoint, end: CGPoint, error: CGFloat, axis: Axis) -> Direction {

        let delta = end - start

        if max(fabs(delta.x), fabs(delta.y)) > error {

            if axis == Axis.Horizontal {
                if delta.x > 0.0 {
                    return Direction.Right
                } else {
                    return Direction.Left
                }
            } else if axis == Axis.Vertical {
                if delta.y > 0.0 {
                    return Direction.Up
                } else {
                    return Direction.Down
                }
            } else {
                if fabs(delta.x) > fabs(delta.y) {
                    if delta.x > 0.0 {
                        return Direction.Right
                    } else {
                        return Direction.Left
                    }
                } else {
                    if delta.y > 0.0 {
                        return Direction.Up
                    } else {
                        return Direction.Down
                    }
                }
            }
        }

        return Direction.None
    }

    func getDirFromPointsWithError(start: CGPoint, end: CGPoint, error: CGFloat) -> Direction {
        return getDirFromPointsWithErrorForceAxis(start, end: end, error: error, axis: Axis.None)
    }

    func getDirFromPointsForceAxis(start: CGPoint, end: CGPoint, axis: Axis) -> Direction {
        return getDirFromPointsWithErrorForceAxis(start, end: end, error: 0.0, axis: axis)
    }

    func getDirFromPoints(start: CGPoint, end: CGPoint) -> Direction {
        return getDirFromPointsWithErrorForceAxis(start, end: end, error: 0.0, axis: Axis.None)
    }

    func setDirs(start: CGPoint, end: CGPoint) {

        toDirection = getDirFromPoints(start, end: end)

        switch toDirection {
        case Direction.Left:
            fromDirection = Direction.Right
        case Direction.Right:
            fromDirection = Direction.Left
        case Direction.Up:
            fromDirection = Direction.Down
        case Direction.Down:
            fromDirection = Direction.Up
        default:
            fromDirection = Direction.None
        }
    }
    
    func getPlacePosition(place: (row: Int, column: Int)) -> CGPoint {
        return GameScene.boardPositions[place.row][place.column]
    }

    // MARK: Methods - Game

    func checkAndChangeGameState() {

//        counter.pause()

        var gameIsWon: Bool = true
        var gameIsOver: Bool = false

        // first check for game won

        for (key, value) in currentTargets {
            if value != levelInfo.colorTargets[key] {
                gameIsWon = false
                break
            }
        }

//        debugPrint("game won \(gameIsWon)")
        if gameIsWon {
            gameWon()
            return
        }

        // then check for game over

        for (key, value) in currentTargets {
            if value != levelInfo.colorTargets[key] && value + 3 > levelInfo.colorTargets[key]  {
                gameIsOver = true
//                debugPrint("game over?")
                break
            }
        }

        if levelInfo.type == LevelType.LimitedMoves {
            if moves >= levelInfo.typeCounter {
                gameIsOver = true
            }
        }

//        debugPrint("game over \(gameIsOver)")
        if gameIsOver {
            gameOver()
            return
        }

//        counter.start()

    }

    func startGame() {
        counter.start()
    }

    func gameOver() {
        prepareButtonsForLose()
        toogleMenu(true)
    }

    func gameWon() {
        prepareButtonsForWin()
        toogleMenu(true)

        flyStarsIn()

//        debugPrint("set level stars")
        let levelStars = currentStars.filter({ $1 != false }).count

        levelsInfo.setLevelStars(levelInfo, stars: levelStars)

        if !gameVC.lobbyVC.sectionsToReload.contains(levelInfo.section) {
            gameVC.lobbyVC.sectionsToReload.append(levelInfo.section)
            debugPrint(gameVC.lobbyVC.sectionsToReload)
        }
    }

    func flyStarsIn() {

        for winStarShadow in winStarsShadows {
            addChild(winStarShadow)
        }

        var count: Int = 0
        for (key, value) in currentStars where value != false {

            let headerPosition = topSmallTiles[key]!.convertPoint(topSmallStars[key]!.position, toNode: scene!)

            topSmallStars[key]!.removeFromParent()

            topSmallStars[key]!.zPosition = 6
            topSmallStars[key]!.position = headerPosition

            addChild(topSmallStars[key]!)

            topSmallStars[key]!.runAction(SKAction.group([
                SKAction.moveTo(winStarsShadows[count].position, duration: 0.5),
                SKAction.scaleTo(winStarsShadows[count].xScale, duration: 0.5),
                SKAction.rotateToAngle(0, duration: 0.5)
            ]))

            count += 1
        }

    }

    func removeWinStarsShadows() {
        for winStarShadow in winStarsShadows {
            winStarShadow.removeFromParent()
        }
    }

    func nextLevel() {

        let starsInSection = levelsInfo.starsInSection(levelInfo.section)

        if levelInfo.number + 1 >= levelsInfo.levelsPerSection && starsInSection < levelsInfo.starsToPassSection {
            goToLobby()
            return
        }

        removeWinStarsShadows()

        if levelInfo.section < levelsInfo.totalSections - 1 {

            var section = levelInfo.section
            var number = levelInfo.number

            number += 1

            if number >= levelsInfo.levelsPerSection {
                section += 1
                number = 0
            }

            gameVC.lobbyVC.saveLastIndexPath(NSIndexPath(forItem: number, inSection: section))

            levelInfo = levelsInfo.loadLevel(section, number: number)
//            debugPrint(levelInfo.type)
            // TODO: what if last level in game?
        }

        changeLevelWith(levelInfo)

        toogleMenu(true)
        prepareButtonsForPause()

    }

    func pauseGame() {
        if gameIsStarted { counter.pause() }
    }

    func resumeGame() {
        if gameIsStarted { counter.start() }
    }

    func restartGame() {
        gameIsStarted = false

        removeWinStarsShadows()
        changeLevelWith(levelInfo)
        prepareButtonsForPause()
        toogleMenu(true)
    }

    // MARK: Methods - Counter closures

    func counterLoop(value: NSTimeInterval) {
        if levelInfo.type == LevelType.LimitedTime {
            headerTopLabel.text = timeFromSeconds(levelInfo.typeCounter - Int(value))
        }

    }

    func counterEnd() {
//        debugPrint("end callback")
        if levelInfo.type == LevelType.LimitedTime {
//            debugPrint("end callback limited time")
            gameOver()
        }
    }

    // MARK: Methods - Buttons actions

    func showAd() {
        debugPrint("Show ad")
    }

    func share() {

    }

    func goToLobby() {
        toogleMenuOff(false)
        counter.stop()
        gameVC!.dismissViewControllerAnimated(true) { [unowned self] in
            self.menu = nil
            self.overlay = nil
            self.counter = nil
        }
    }

    // MARK: Menu related methods

    func toogleMenu(animated: Bool) {
        if gameIsPaused {
            toogleMenuOff(animated)
        } else {
            toogleMenuOn(animated)
        }
    }

    func toogleMenuOn(animated: Bool) {

        if overlay.parent == nil && menu.parent == nil  && !gameIsPaused{

            pauseGame()

            gameIsPaused = true
            addChild(overlay)
            addChild(menu)

            if animated {
                overlay.runAction(SKAction.fadeAlphaTo(overlayAlpha, duration: menuToogleInterval))
                menu.runAction(SKAction.fadeInWithDuration(menuToogleInterval))
            } else {
                overlay.alpha = overlayAlpha
                menu.alpha = 1
            }
        }
    }

    func toogleMenuOff(animated: Bool) {
        if overlay.parent != nil && menu.parent != nil && gameIsPaused {

            gameIsPaused = false

            if animated {
                menu.runAction(SKAction.fadeOutWithDuration(menuToogleInterval)) { [unowned self] in
                    self.menu.removeFromParent()
                    if self.gameIsStarted { self.resumeGame() }
                }

                overlay.runAction(SKAction.fadeOutWithDuration(menuToogleInterval)) { [unowned self] in
                    self.overlay.removeFromParent()
                }
            } else {
                if gameIsStarted { resumeGame() }
                menu.removeFromParent()
                overlay.removeFromParent()
                menu.alpha = 0
                overlay.alpha = 0
            }
        }
    }

    // MARK: App goes to background

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

        menuTopButtonLabel.removeFromParent()

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

        let menuBackgroundWidth: CGFloat = GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x
        let buttonMargin: CGFloat = Tile.tileSize.width / 3
        let buttonWidth: CGFloat = (menuBackgroundWidth - buttonMargin * 4) / 3

        menuRestartIcon.anchorPoint.x = 0.5
        menuRestartIcon.position.x = buttonWidth / 2

        menuShareIcon.removeFromParent()
        menuRightButton.removeAllChildren()
        menuRightButton.addChild(menuShareIcon)

        menuTopButton.color = Constants.textColor
        menuTopButton.name = ButtonType.Ad.rawValue
        menuTopButtonLabel.text = "Video Ad"
        menuTopButtonLabel.name = ButtonType.Ad.rawValue

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

        let menuBackgroundWidth: CGFloat = GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x
        let buttonMargin: CGFloat = Tile.tileSize.width / 3
        let buttonWidth: CGFloat = (menuBackgroundWidth - buttonMargin * 4) / 3

        menuRestartIcon.removeFromParent()
        menuRightButton.removeAllChildren()
        menuRightButton.addChild(menuRestartIcon)

        menuRestartIcon.anchorPoint.x = 1
        menuRestartIcon.position.x = buttonWidth

        menuTopButton.name = ButtonType.Empty.rawValue
        menuTopButton.color = UIColor.clearColor()

        menuTopButtonLabel.name = ButtonType.Empty.rawValue
        menuTopButtonLabel.text = "PAUSE"

    }

    // MARK: Methods - Create Methods

    func changeLevelWith(level: LevelInfo) {

        self.canTouch = false

        resetTargetsTo(levelInfo)

        for i in 0 ..< 6 {
            for j in 0 ..< 6 {

                if let tile = tiles[i][j] where tile.type != TileType.Hole {
                    tiles[i][j] = nil
                    tile.runAction(SKAction.scaleTo(0, duration: tilesDissappearInterval)) {
                        tile.removeFromParent()
                    }
                }

                if let backTile = backgroundTiles[i][j] {
                    backgroundTiles[i][j] = nil

                    backTile.runAction(SKAction.moveTo(CGPoint.zero, duration: tilesAppearInterval)) {
                        backTile.removeFromParent()
                    }
                }
            }
        }

        addBoardBackgroundAndHoles()

        self.runAction(SKAction.waitForDuration(tilesDissappearInterval + 0.2)) { [unowned self] in
            self.addBoardTiles()
        }
    }

    func resetTargetsTo(levelInfo: LevelInfo) {

        // Removing current state

        for (_, value) in topSmallStars {
            value.removeFromParent()
        }

        topSmallStars.removeAll(keepCapacity: false)

        for (key, _) in headerPositions {
            topSmallTiles[key]!.removeFromParent()
            colorLabels[key]!.removeFromParent()
        }

        topSmallTiles.removeAll(keepCapacity: false)
        colorLabels.removeAll(keepCapacity: false)
        headerPositions.removeAll(keepCapacity: false)
        currentTargets.removeAll(keepCapacity: false)
        currentStars.removeAll(keepCapacity: false)

        // Add new state

        moves = 0
        gameIsStarted = false

        if levelInfo.type == LevelType.LimitedMoves {
            headerBottomLabel.text = "moves"
            headerTopLabel.text = "\(levelInfo.typeCounter)"
        }

        if levelInfo.type == LevelType.LimitedTime {
            headerBottomLabel.text = "time"
            headerTopLabel.text = timeFromSeconds(levelInfo.typeCounter)
        }

        if levelInfo.type == LevelType.FreeTime {
            headerBottomLabel.text = "level"
            headerTopLabel.text = "\(levelInfo.levelNumber)"
        }

        if let counter = self.counter {
            counter.stop()

            if levelInfo.type != LevelType.LimitedMoves {
                counter.endInterval = NSTimeInterval(levelInfo.typeCounter)
            }
        } else {
            counter = Counter(loopInterval: 1.0, endInterval: NSTimeInterval(levelInfo.typeCounter), loopCallback: self.counterLoop, endCallback: self.counterEnd)

            debugPrint("new counter")
        }

        let colorsCount: Int = levelInfo.colorTargets.filter({ $1 != 0 }).count

        let smallTileWidth = Tile.tileLength / 2
        let widthWithoutLeftRightButtons = Constants.screenSize.width - Tile.tileLength * 2
        let yMiddle = Tile.tileLength / 2
        let space = (widthWithoutLeftRightButtons - 5 * smallTileWidth) / 6
        let actualTilesWidth = CGFloat(colorsCount) * smallTileWidth + CGFloat(colorsCount - 1) * space
        let diffWidth = Constants.screenSize.width - actualTilesWidth
        let startX = diffWidth / 2 + smallTileWidth / 2

        let orderedKeys: [TileType] = [
            TileType.Color1,
            TileType.Color2,
            TileType.Color3,
            TileType.Color4,
            TileType.Color5,
        ]

        for (index, value) in orderedKeys.enumerate() where levelInfo.colorTargets[value] != 0 {

            // Create header tiles positions in order
            let x = startX + CGFloat(index) * (space + smallTileWidth)
            headerPositions[value] = CGPointMake(x, yMiddle)

            // add top tiles

            let tile = SKSpriteNode(texture: Textures.tileTopTexture,
                color: value.tileColor,
                size: Tile.tileSize / 2)

            tile.zPosition = 1
            tile.colorBlendFactor = 1.0
            tile.position = headerPositions[value]!
            tile.position.y += Tile.tileLength / 8
            tile.zPosition = 1

            topSmallTiles[value] = tile
            headerBackground.addChild(tile)

            currentTargets[value] = 0

            if levelInfo.starTargets[value] != false {
                let star = SKSpriteNode(texture: Textures.starTexture,
                    color: Constants.textColor,
                    size: Tile.tileSize / 4)

                star.colorBlendFactor = 1.0
                star.zRotation = degree2radian(-15)
                star.zPosition = 1

                topSmallStars[value] = star
                tile.addChild(star)
                currentStars[value] = false
            }

            // add labels
            let label = SKLabelNode()
            label.fontColor = Constants.backgroundColor
            label.fontName = Constants.primaryFont
            label.text = "00/00"
            label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center

            let labelSizeRatio: CGFloat = Tile.tileLength / 8 * 1.5 / label.frame.height
            label.fontSize *= labelSizeRatio
            label.position = headerPositions[value]!
            label.position.y -= Tile.tileLength / 8 * 2.5
            label.zPosition = 1
            
            colorLabels[value] = label
            colorLabels[value]!.text = "\(0)/\(levelInfo.colorTargets[value]!)"
            
            headerBackground.addChild(label)
        }
    }

    func addBoardTiles() {

        canTouch = false

        for i in 0 ... 5 {
            for j in 0 ... 5 {
                if levelInfo.mainTiles[i][j] != TileType.Hole &&
                    levelInfo.mainTiles[i][j] != TileType.Empty {
                        addTile(i, column: j)
                }
            }
        }

        self.runAction(SKAction.waitForDuration(tilesAppearInterval + 0.1)) { [unowned self] in
            self.canTouch = true
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
                    addBoardHole(i, column: j)
                } else {
                    addBoardBackgroundTile(i, column: j)
                }
            }
        }
    }

    func addBoardHole(row: Int, column: Int) {
        let holeTile = Tile(row: row, column: column, tileType: TileType.Hole, delegate: self)
        holeTile.position = GameScene.boardPositions[row][column]
        holeTile.hidden = true
        tiles[row][column] = holeTile
        addChild(holeTile)
    }

    func addBoardBackgroundTile(row: Int, column: Int) {
        let backTile = SKSpriteNode(texture: Textures.tileBackgroundTexture, color: Constants.textColor, size: Tile.tileSize)
        backTile.colorBlendFactor = 1
        backTile.zPosition = 1

        backgroundTiles[row][column] = backTile

        // funny animation
        let corners: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 500),
            CGPoint(x: 300, y: 0),
            CGPoint(x: 300, y: 500),
        ]

        backTile.position = corners[random() % 4]

        addChild(backTile)
        backTile.runAction(SKAction.moveTo(GameScene.boardPositions[row][column], duration: tilesAppearInterval))
        
    }

    func createOverlay() {
        overlay = SKSpriteNode(color: Constants.textColor, size: size);
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
            color: Constants.backgroundColor, size: menuBackgroundSize)

        menuBackground.colorBlendFactor = 1.0
        menuBackground.anchorPoint = CGPointZero
        menuBackground.position = GameScene.boardPositions[5][0]
        menuBackground.zPosition = 5

        // menu 1/3 line

        let menuLineWidth: CGFloat = menuBackgroundWidth - Tile.tileLength * 2/3
        let menuLineSize = CGSize(width: menuLineWidth, height: 2)
        let menuLine: SKSpriteNode = SKSpriteNode(color: Constants.orangeColor, size: menuLineSize)

        menuLine.position.y = menuBackgroundHeight / 3
        menuLine.position.x = Tile.tileLength * 1/3
        menuLine.anchorPoint.x = 0
        menuLine.zPosition = 1
        menuBackground.addChild(menuLine)

        // add buttons

        let buttonMargin: CGFloat = Tile.tileSize.width / 3
        let buttonHeight: CGFloat = (menuBackgroundHeight - buttonMargin * 4) / 3
        let buttonWidth: CGFloat = (menuBackgroundWidth - buttonMargin * 4) / 3
        let topButtonWidth: CGFloat = menuBackgroundWidth - buttonMargin * 2

        let menuButtonsSize: CGSize = CGSize(width: buttonWidth, height: buttonHeight)
        let menuTopButtonsSize: CGSize = CGSize(width: topButtonWidth, height: buttonHeight)

        menuLeftButton = SKSpriteNode(texture: Textures.menuLeftButtonTexture,
            color: UIColor.clearColor(), size: menuButtonsSize)

        menuMiddleButton = SKSpriteNode(texture: Textures.menuMiddleButtonTexture,
            color: UIColor.clearColor(), size: menuButtonsSize)

        menuRightButton = SKSpriteNode(texture: Textures.menuRightButtonTexture,
            color: UIColor.clearColor(), size: menuButtonsSize)

        menuTopButton = SKSpriteNode(texture: Textures.menuTopButtonTexture,
            color: UIColor.clearColor(), size: menuTopButtonsSize)

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

        let iconSize: CGSize = CGSize(width: buttonHeight * 4/5, height: buttonHeight * 4/5)

        let lobbyIconTexture: SKTexture = SKTexture(imageNamed: "Lobby")
        let lobbyIcon: SKSpriteNode = SKSpriteNode(texture: lobbyIconTexture, size: iconSize)

        menuLeftButton.addChild(lobbyIcon)
        lobbyIcon.name = ButtonType.Lobby.rawValue
        lobbyIcon.zPosition = 1
        lobbyIcon.anchorPoint = CGPoint.zero

        let pauseIconTexture: SKTexture = SKTexture(imageNamed: "Play")
        menuPauseIcon = SKSpriteNode(texture: pauseIconTexture, size: iconSize)
        menuMiddleButton.addChild(menuPauseIcon)
        menuPauseIcon.name = ButtonType.Pause.rawValue
        menuPauseIcon.zPosition = 1
        menuPauseIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
        menuPauseIcon.position.x = buttonWidth / 2

        let restartIconTexture: SKTexture = SKTexture(imageNamed: "Restart")
        menuRestartIcon = SKSpriteNode(texture: restartIconTexture, size: iconSize)
        menuRightButton.addChild(menuRestartIcon)
        menuRestartIcon.name = ButtonType.Restart.rawValue
        menuRestartIcon.zPosition = 1
        menuRestartIcon.anchorPoint = CGPoint(x: 1, y: 0)
        menuRestartIcon.position.x = buttonWidth

        let shareTexture: SKTexture = SKTexture(imageNamed: "Share")
        menuShareIcon = SKSpriteNode(texture: shareTexture, size: iconSize)
        menuShareIcon.name = ButtonType.Share.rawValue
        menuShareIcon.zPosition = 1
        menuShareIcon.anchorPoint = CGPoint(x: 1, y: 0)
        menuShareIcon.position.x = buttonWidth

        let nextIconTexture: SKTexture = SKTexture(imageNamed: "Play")
        menuNextIcon = SKSpriteNode(texture: nextIconTexture, size: iconSize)
        menuNextIcon.name = ButtonType.Next.rawValue
        menuNextIcon.zPosition = 1
        menuNextIcon.anchorPoint = CGPoint(x: 0.5, y: 0)
        menuNextIcon.position.x = buttonWidth / 2

        // add top label

        menuTopButtonLabel = SKLabelNode()
        menuTopButtonLabel.fontName = Constants.primaryFont
        menuTopButtonLabel.fontColor = Constants.cyanColor
        menuTopButtonLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        menuTopButtonLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        menuTopButtonLabel.position.x = menuTopButton.size.width / 2
        menuTopButtonLabel.position.y = menuTopButton.size.height / 2
        menuTopButtonLabel.zPosition = 1
        menuTopButtonLabel.text = "PAUSE"

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
        menuMiddleLabel.text = "Lorem ipsum dolor sit amet"

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
        headerBottomLabel.fontColor = Constants.backgroundColor
        headerBottomLabel.fontName = Constants.primaryFont
        headerBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        headerBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        headerBottomLabel.zPosition = 1
        headerBottomLabel.setTextWithinSize("AAAAA", size: tileTwoThirds, vertically: false)

        headerTopLabel = SKLabelNode()
        headerTopLabel.fontColor = Constants.backgroundColor
        headerTopLabel.fontName = Constants.primaryFont
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

        headerBackground = SKSpriteNode(color: Constants.textColor,
                                        size: CGSize(width: Constants.screenSize.width, height: Tile.tileLength))

        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        headerBackground.position = CGPoint(x: 0, y: Constants.screenSize.height - Tile.tileLength)
        headerBackground.zPosition = 5

        headerLeftIcon = SKSpriteNode(color: Constants.textColor, size: Tile.tileSize)

        headerLeftIcon.position = CGPoint(x: Tile.tileLength / 2, y: Tile.tileLength / 2)
        headerLeftIcon.colorBlendFactor = 1.0
        headerLeftIcon.zPosition = 1
        headerBackground.addChild(headerLeftIcon)

        setupHeaderLeftLabels()

        // add right button

        pauseButton = SKSpriteNode(color: Constants.textColor, size: Tile.tileSize)

        pauseButton.colorBlendFactor = 1.0
        pauseButton.zPosition = 1
        pauseButton.position = CGPointMake(Constants.screenSize.width - Tile.tileLength / 2, Tile.tileLength / 2)
        pauseButton.name = ButtonType.Pause.rawValue

        // add pause image to button

        pauseIcon = SKSpriteNode(texture: SKTexture(imageNamed: "Pause"),
            color: Constants.backgroundColor, size: Tile.tileSize / 2)
        pauseIcon.colorBlendFactor = 1.0
        pauseIcon.name = ButtonType.Pause.rawValue
        pauseIcon.zPosition = 1

        pauseButton.addChild(pauseIcon)
        headerBackground.addChild(pauseButton)

        resetTargetsTo(levelInfo)
        
        addChild(headerBackground)
    }

    func createWinStarsShadows() {

        let firstStarShadow = SKSpriteNode(texture: Tile.starOutlineTexture, color: Constants.yellowColor, size: Tile.tileSize)
        let secondStarShadow = SKSpriteNode(texture: Tile.starOutlineTexture, color: Constants.yellowColor, size: Tile.tileSize)
        let thirdStarShadow = SKSpriteNode(texture: Tile.starOutlineTexture, color: Constants.yellowColor, size: Tile.tileSize)

        firstStarShadow.colorBlendFactor = 1.0
        secondStarShadow.colorBlendFactor = 1.0
        thirdStarShadow.colorBlendFactor = 1.0

        firstStarShadow.zPosition = 6
        secondStarShadow.zPosition = 6
        thirdStarShadow.zPosition = 6

        var topButtonCenter: CGPoint = menuTopButton.position
        topButtonCenter.x += menuTopButton.size.width / 2
        topButtonCenter.y += menuTopButton.size.height / 2

        let pos: CGPoint = menu.convertPoint(topButtonCenter, toNode: self)

        firstStarShadow.position = pos
        secondStarShadow.position = pos
        thirdStarShadow.position = pos

        firstStarShadow.position.x -= Tile.tileLength
        thirdStarShadow.position.x += Tile.tileLength

        winStarsShadows.append(firstStarShadow)
        winStarsShadows.append(secondStarShadow)
        winStarsShadows.append(thirdStarShadow)
    }

    static func createBoardPositions() -> [[CGPoint]] {

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
    }

    // MARK: Misc methods

    func timeFromSeconds(totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }
}