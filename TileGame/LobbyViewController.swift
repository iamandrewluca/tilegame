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

    @IBAction func goBack(_ sender: AnyObject) {
        AudioPlayer.tap()
        navigationController!.popViewController(animated: true)
    }

    @IBAction func openLeaderboard(_ sender: AnyObject) {
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

    fileprivate func setupLockedSectionHeaderAtIndexPath(_ view: LobbyHeader, indexPath: IndexPath) {

        let starsToPass  = levelsInfo?.starsToPassSection - levelsInfo?.starsInSection(indexPath.section - 1)

        view.sectionLabel.text = "Section \(indexPath.section + 1)"
        view.starsLabel.text = "\(starsToPass) stars to unlock"
    }

    fileprivate func setupSectionHeaderAtIndexPath(_ view: LobbyHeader, indexPath: IndexPath) {

        let totalStars = levelsInfo?.starsInSection(indexPath.section)

        view.sectionLabel.text = "Section \(indexPath.section + 1)"
        view.starsLabel.text = "\(totalStars) stars"
    }

    fileprivate func setupCellWithIndexPath(_ cell: LobbyCell, indexPath: IndexPath) {
        let cellLevel = String(1 + indexPath.section * (levelsInfo?.levelsPerSection)! + indexPath.item)
        cell.levelNumber.text = cellLevel

        let levelStars = levelsInfo?.starsAtIndexPath(indexPath)

        if levelStars > 0 {
            cell.firstStar.image = LobbyCell.starImage
            if levelStars > 1 {
                cell.secondStar.image = LobbyCell.starImage
                if levelStars > 2 {
                    debugPrint("jora")
                    cell.thirdStar.image = LobbyCell.starImage
                    cell.backgroundColor = Constants.allStarsCellBackgroundColor
                    cell.levelNumber.textColor = Constants.allStarsTextColor
                }
            }
        }
    }

    fileprivate func setupLockedCellWithIndexPath(_ cell: LobbyLockedCell, indexPath: IndexPath) {

    }

    fileprivate func registerNibsForCollectionView() {
        collectionView!.register(UINib(nibName: LobbyHeader.identifier, bundle: nil),
            forSupplementaryViewOfKind: LobbyHeader.identifier, withReuseIdentifier: LobbyHeader.identifier)

        collectionView!.register(UINib(nibName: LobbyCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LobbyCell.identifier)

        collectionView!.register(UINib(nibName: LobbyLockedCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LobbyLockedCell.identifier)
    }

    fileprivate func setupViews() {

        navigationHeaderHeight.constant = Tile.tileLength

        let backMask = CAShapeLayer()
        backMask.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: Tile.tileLength, height: Tile.tileLength),
            byRoundingCorners: UIRectCorner.topRight,
            cornerRadii: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2)).cgPath

        let leaderboardMask = CAShapeLayer()
        leaderboardMask.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: Tile.tileLength, height: Tile.tileLength),
            byRoundingCorners: UIRectCorner.topLeft,
            cornerRadii: CGSize(width: Tile.tileLength / 2, height: Tile.tileLength / 2)).cgPath

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

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibsForCollectionView()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        middleLabel.text = "\(levelsInfo?.totalStars()) stars"

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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelsInfo!.levelsPerSection
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        if levelsInfo?.unlockedSections == levelsInfo?.totalSections {
            return levelsInfo!.totalSections
        }

        return levelsInfo!.unlockedSections + 1
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!

        if indexPath.section < (levelsInfo?.unlockedSections)! {
            cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LobbyCell.identifier, for: indexPath) as! LobbyCell

            setupCellWithIndexPath(cell as! LobbyCell, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LobbyLockedCell.identifier, for: indexPath) as! LobbyLockedCell

            setupLockedCellWithIndexPath(cell as! LobbyLockedCell, indexPath: indexPath)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        var supplementaryView: UICollectionReusableView!

        if kind == LobbyHeader.identifier {

            supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                withReuseIdentifier: LobbyHeader.identifier,
                for: indexPath) as! LobbyHeader

            if indexPath.section < (levelsInfo?.unlockedSections)! {
                setupSectionHeaderAtIndexPath(supplementaryView as! LobbyHeader, indexPath: indexPath)
            } else {
                setupLockedSectionHeaderAtIndexPath(supplementaryView as! LobbyHeader, indexPath: indexPath)
            }
        }

        return supplementaryView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.section < (levelsInfo?.unlockedSections)! {

            let gameVC = storyboard!.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
            gameVC.lobbyVC = self
            gameVC.levelInfo = levelsInfo!.loadLevel(indexPath.section, number: indexPath.item)

            saveLastIndexPath(indexPath)

            AudioPlayer.tap()

            navigationController!.present(gameVC, animated: true, completion: nil)
        }
    }

    /**
     We can't save an NSIndexPath in user defaults

     - parameter indexPath: index path to save in user defaults
     */
    func saveLastIndexPath(_ indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.item, forKey: LAST_INDEX_PATH_ITEM_KEY)
        UserDefaults.standard.set(indexPath.section, forKey: LAST_INDEX_PATH_SECTION_KEY)
    }

    /**
     Loads index path for last played game

     - returns: NSIndexPath?
     */
    func loadLastIndexPath() -> IndexPath? {

        var lastIndexPath: IndexPath? = IndexPath?.none

        if let lastIndexPathItem = UserDefaults.standard.value(forKey: LAST_INDEX_PATH_ITEM_KEY) as! Int!,
            let lastIndexPathSection = UserDefaults.standard.value(forKey: LAST_INDEX_PATH_SECTION_KEY) as! Int!{
                lastIndexPath = IndexPath(item: lastIndexPathItem, section: lastIndexPathSection)
        }

        return lastIndexPath
    }

    func scrollToLastIndexPath() {
        if let lastIndexPath = loadLastIndexPath() {
            collectionView.scrollToItem(
                at: lastIndexPath,
                at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
    }

}
