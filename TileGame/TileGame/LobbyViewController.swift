//
//  LobbyViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var levels: Levels!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func goBack(sender: AnyObject) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.levelsPerSection
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return levels.totalSections
    }
    
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

    private func setupLockedCellWithIndexPath(cell: LobbyLockedCell, indexPath: NSIndexPath) {

    }

    private func setupCellWithIndexPath(cell: LobbyCell, indexPath: NSIndexPath) {
        let cellLevel = String(1 + indexPath.section * levels.levelsPerSection + indexPath.item)
        cell.levelNumber.text = cellLevel

        let levelStars = rand() % 4//levels.starsAtIndexPath(indexPath)

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
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        var header = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: Identifiers.lobbyHeader,
            forIndexPath: indexPath) as! LobbyHeader

        header.headerLabel.text = "+3 start to open"
        return header
    }
        
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

    private func setButton(image : UIImage!, tintColor : UIColor, state : UIControlState) {
        let backImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        backButton.setImage(backImage, forState: state)
        backButton.tintColor = tintColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
