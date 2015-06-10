//
//  LobbyViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: LobbyCollectionViewLayout!
    @IBOutlet weak var backButton: UIButton!

    var levels: Levels!
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.levelsPerSection
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return levels.totalSections
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            Identifiers.lobbyCell, forIndexPath: indexPath) as! LobbyCollectionViewCell

        setupCellWithIndexPath(cell, indexPath: indexPath)

        return cell
    }

    private func setupCellWithIndexPath(cell: LobbyCollectionViewCell, indexPath: NSIndexPath) {
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
            forIndexPath: indexPath) as! LobbyCollectionViewHeader

        header.headerLabel.text = "+3 start to open"
        return header
    }
        
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerNib(UINib(nibName: "LobbyCollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: Identifiers.lobbyHeader, withReuseIdentifier: Identifiers.lobbyHeader)

        setButton(UIImage(named: "Back"),
            tintColor: UIColor.grayColor(),
            state: UIControlState.Normal)
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
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            if identifier == Identifiers.gameSceneSegue {
                let cell = sender as! LobbyCollectionViewCell
                let indexPath = self.collectionView.indexPathForCell(cell)!
                let gameCtrl: GameViewController = segue.destinationViewController as! GameViewController
                gameCtrl.section = indexPath.section
                gameCtrl.level = indexPath.item
            }
        }
    }


}
