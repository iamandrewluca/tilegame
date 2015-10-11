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
        navigationController!.popViewControllerAnimated(true)
    }

    @IBAction func openLeaderboard(sender: AnyObject) {
        debugPrint("leaderboard")
    }

    // MARK: Members

    static let gameSceneSegueIdentifier = "toGameScene"

    var levelsInfo = LevelsInfo.sharedInstance

    var shouldReload: Bool = false

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
            cell.firstStar.tintColor = Constants.starColor
            if levelStars > 1 {
                cell.secondStar.tintColor = Constants.starColor
                if levelStars > 2 {
                    cell.thirdStar.tintColor = Constants.starColor
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

        backButtonContainer.backgroundColor = Constants.navigationButtonColor
        leaderboardButtonContainer.backgroundColor = Constants.navigationButtonColor
        navigationView.backgroundColor = Constants.navigationBackgroundColor
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

        middleLabel.text = "\(levelsInfo.totalStars()) stars"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if shouldReload {
            collectionView.reloadData()
            shouldReload = false
        }

        collectionView.scrollToItemAtIndexPath(
            NSIndexPath(forItem: 0, inSection: levelsInfo.unlockedSections - 1),
            atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
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

            shouldReload = true

            let gameVC = storyboard!.instantiateViewControllerWithIdentifier("gameVC") as! GameViewController
            gameVC.levelInfo = levelsInfo.loadLevel(indexPath.section, number: indexPath.item)

            navigationController!.presentViewController(gameVC, animated: true, completion: nil)
        }
    }
}
