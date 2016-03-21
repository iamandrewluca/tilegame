//
//  LobbyViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: IB Outlets

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var navigationHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var backButtonContainer: UIView!
    @IBOutlet weak var leaderboardButtonContainer: UIView!
    @IBOutlet weak var middleLabel: UILabel!

    // MARK: IB Actions

    @IBAction func goBack(sender: AnyObject) {
        AudioPlayer.tap()
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func openLeaderboard(sender: AnyObject) {
        AudioPlayer.tap()
        debugPrint("leaderboard")
    }

    // MARK: Members

    static let gameSceneSegueIdentifier = "toGameScene"

    var levelsInfo = LevelsInfo.sharedInstance

    var sectionsToReload: [Int] = []

    let LAST_INDEX_PATH_ITEM_KEY: String = "LAST_INDEX_PATH_ITEM_KEY"
    let LAST_INDEX_PATH_SECTION_KEY: String = "LAST_INDEX_PATH_SECTION_KEY"


    // MARK: Methods

    private func setupLockedSectionHeaderAtIndexPath(view: LobbyHeader, indexPath: NSIndexPath) {

        let starsToPass  = levelsInfo.starsToPassSection - levelsInfo.starsInSection(indexPath.section - 1)

        view.headerLabel.text = "+\(starsToPass) stars in section \(indexPath.section) to unlock"
    }

    private func setupSectionHeaderAtIndexPath(view: LobbyHeader, indexPath: NSIndexPath) {

        let totalStars = levelsInfo.starsInSection(indexPath.section)
        view.headerLabel.text = "\(totalStars) stars in section \(indexPath.section + 1)"
    }

    private func setupCellWithIndexPath(cell: LobbyCell, indexPath: NSIndexPath) {
        let cellLevel = String(1 + indexPath.section * levelsInfo.levelsPerSection + indexPath.item)
        cell.levelNumber.text = cellLevel

        let levelStars = levelsInfo.starsAtIndexPath(indexPath)

        if levelStars > 0 {
            cell.firstStar.tintColor = Constants.Color3
            if levelStars > 1 {
                cell.secondStar.tintColor = Constants.Color3
                if levelStars > 2 {
                    cell.thirdStar.tintColor = Constants.Color3
                }
            }
        }
    }

    private func setupLockedCellWithIndexPath(cell: LobbyLockedCell, indexPath: NSIndexPath) {

    }

    private func registerNibsForCollectionView() {
        collectionView!.registerNib(UINib(nibName: LobbyHeader.identifier, bundle: nil),
            forSupplementaryViewOfKind: LobbyHeader.identifier, withReuseIdentifier: LobbyHeader.identifier)

        collectionView!.registerNib(UINib(nibName: LobbyCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LobbyCell.identifier)

        collectionView!.registerNib(UINib(nibName: LobbyLockedCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LobbyLockedCell.identifier)
    }

    private func setupViews() {

        navigationHeaderHeight.constant = Tile.tileLength

        let backMask = CAShapeLayer()
        backMask.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: Tile.tileLength, height: Tile.tileLength),
            byRoundingCorners: UIRectCorner.TopRight,
            cornerRadii: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2)).CGPath

        let leaderboardMask = CAShapeLayer()
        leaderboardMask.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: Tile.tileLength, height: Tile.tileLength),
            byRoundingCorners: UIRectCorner.TopLeft,
            cornerRadii: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2)).CGPath

        leaderboardButtonContainer.layer.mask = leaderboardMask
        backButtonContainer.layer.mask = backMask

        backButtonContainer.backgroundColor = Constants.Color5
        leaderboardButtonContainer.backgroundColor = Constants.Color5
        navigationView.backgroundColor = Constants.Color5
        middleLabel.textColor = Constants.textColor
        collectionView.backgroundColor = Constants.backgroundColor

        leaderboardButton.tintColor = Constants.textColor
        backButton.tintColor = Constants.textColor
    }

    // MARK: UIViewController

    deinit {
        debugPrint("lobby deinit")
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsForCollectionView()

        setupViews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        middleLabel.text = "\(levelsInfo.totalStars()) stars"

        if sectionsToReload.count != 0 {
//            debugPrint("reload sections")
//            debugPrint(sectionsToReload)
//            debugPrint(collectionView.numberOfSections())
//
//            let sectionsRange = NSRange.init(location: sectionsToReload.first!, length: sectionsToReload.count)
//
//            debugPrint("before reload")
//            collectionView.reloadSections(NSIndexSet(indexesInRange: sectionsRange))
//            debugPrint("afeter reload")

            // TODO: If performance issues above code must be fixed
            // for now w'll reload entire collectionview
            collectionView.reloadData()

            sectionsToReload.removeAll()
        }

        scrollToLastIndexPath()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        /**
        This is here because collection view first must layou subviews and then scroll
        */
        scrollToLastIndexPath()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelsInfo.levelsPerSection
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        if levelsInfo.unlockedSections == levelsInfo.totalSections {
            return levelsInfo.totalSections
        }

        return levelsInfo.unlockedSections + 1
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!

        if indexPath.section < levelsInfo.unlockedSections {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                LobbyCell.identifier, forIndexPath: indexPath) as! LobbyCell

            setupCellWithIndexPath(cell as! LobbyCell, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                LobbyLockedCell.identifier, forIndexPath: indexPath) as! LobbyLockedCell

            setupLockedCellWithIndexPath(cell as! LobbyLockedCell, indexPath: indexPath)
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var supplementaryView: UICollectionReusableView!

        if kind == LobbyHeader.identifier {

            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: LobbyHeader.identifier,
                forIndexPath: indexPath) as! LobbyHeader

            if indexPath.section < levelsInfo.unlockedSections {
                setupSectionHeaderAtIndexPath(supplementaryView as! LobbyHeader, indexPath: indexPath)
            } else {
                setupLockedSectionHeaderAtIndexPath(supplementaryView as! LobbyHeader, indexPath: indexPath)
            }
        }

        return supplementaryView
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if indexPath.section < levelsInfo.unlockedSections {

            let gameVC = storyboard!.instantiateViewControllerWithIdentifier("gameVC") as! GameViewController
            gameVC.lobbyVC = self
            gameVC.levelInfo = levelsInfo.loadLevel(indexPath.section, number: indexPath.item)

            saveLastIndexPath(indexPath)

            AudioPlayer.tap()

            navigationController!.presentViewController(gameVC, animated: true, completion: nil)
        }
    }

    /**
     We can't save an NSIndexPath in user defaults

     - parameter indexPath: index path to save in user defaults
     */
    func saveLastIndexPath(indexPath: NSIndexPath) {
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.item, forKey: LAST_INDEX_PATH_ITEM_KEY)
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.section, forKey: LAST_INDEX_PATH_SECTION_KEY)
    }

    /**
     Loads index path for last played game

     - returns: NSIndexPath?
     */
    func loadLastIndexPath() -> NSIndexPath? {

        var lastIndexPath: NSIndexPath? = NSIndexPath?.None

        if let lastIndexPathItem = NSUserDefaults.standardUserDefaults().valueForKey(LAST_INDEX_PATH_ITEM_KEY) as! Int!,
            lastIndexPathSection = NSUserDefaults.standardUserDefaults().valueForKey(LAST_INDEX_PATH_SECTION_KEY) as! Int!{
                lastIndexPath = NSIndexPath(forItem: lastIndexPathItem, inSection: lastIndexPathSection)
        }

        return lastIndexPath
    }

    func scrollToLastIndexPath() {
        if let lastIndexPath = loadLastIndexPath() {
            collectionView.scrollToItemAtIndexPath(
                lastIndexPath,
                atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
        }
    }

}
