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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!

    // MARK: IB Actions

    @IBAction func goBack(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }

    // MARK: Members

    var levels: Levels!

    // MARK: Methods

    private func setupLockedSectionHeaderAtIndexPath(view: LobbyHeader, indexPath: NSIndexPath) {

        var starsToPass  = Levels.starsToPassSection - levels.starsInSection(indexPath.section - 1)

        view.headerLabel.text = "\(starsToPass) stars in section \(indexPath.section) to unlock"
    }

    private func setupSectionHeaderAtIndexPath(view: LobbyHeader, indexPath: NSIndexPath) {

        var totalStars = levels.starsInSection(indexPath.section)
        view.headerLabel.text = "\(totalStars) stars in section \(indexPath.section + 1)"
    }

    private func setupCellWithIndexPath(cell: LobbyCell, indexPath: NSIndexPath) {
        let cellLevel = String(1 + indexPath.section * Levels.levelsPerSection + indexPath.item)
        cell.levelNumber.text = cellLevel

        let levelStars = levels.starsAtIndexPath(indexPath)

        if levelStars > 0 {
            cell.firstStar.image = UIImage(named: "Star")
            if levelStars > 1 {
                cell.secondStar.image = UIImage(named: "Star")
                if levelStars > 2 {
                    cell.thirdStar.image = UIImage(named: "Star")
                }
            }
        }
    }

    private func setupLockedCellWithIndexPath(cell: LobbyLockedCell, indexPath: NSIndexPath) {

    }

    private func setButton(image : UIImage!, tintColor : UIColor, state : UIControlState) {
        let backImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        backButton.setImage(backImage, forState: state)
        backButton.tintColor = tintColor
    }

    // MARK: UIViewController

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView!.registerNib(UINib(nibName: "LobbyHeader", bundle: nil), forSupplementaryViewOfKind: Identifiers.lobbyHeader, withReuseIdentifier: Identifiers.lobbyHeader)

        collectionView!.registerNib(UINib(nibName: "LobbyCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.lobbyCell)

        collectionView!.registerNib(UINib(nibName: "LobbyLockedCell", bundle: nil), forCellWithReuseIdentifier: Identifiers.lobbyLockedCell)

        setButton(UIImage(named: "Back"),
            tintColor: UIColor.grayColor(),
            state: UIControlState.Normal)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.scrollToItemAtIndexPath(
            NSIndexPath(forItem: 0, inSection: levels.unlockedSections),
            atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Levels.levelsPerSection
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return levels.totalSections
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!

        if indexPath.section <= levels.unlockedSections {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                Identifiers.lobbyCell, forIndexPath: indexPath) as! LobbyCell

            setupCellWithIndexPath(cell as! LobbyCell, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
                Identifiers.lobbyLockedCell, forIndexPath: indexPath) as! LobbyLockedCell

            setupLockedCellWithIndexPath(cell as! LobbyLockedCell, indexPath: indexPath)
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var header = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: Identifiers.lobbyHeader,
            forIndexPath: indexPath) as! LobbyHeader

        if indexPath.section <= levels.unlockedSections {
            setupSectionHeaderAtIndexPath(header, indexPath: indexPath)
        } else {
            setupLockedSectionHeaderAtIndexPath(header, indexPath: indexPath)
        }

        return header
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if indexPath.section <= levels.unlockedSections {
            let gameVC = storyboard!.instantiateViewControllerWithIdentifier("gameVC") as! GameViewController

            gameVC.section = indexPath.section
            gameVC.level = indexPath.item

            navigationController!.presentViewController(gameVC, animated: true, completion: nil)
        }
    }
}
