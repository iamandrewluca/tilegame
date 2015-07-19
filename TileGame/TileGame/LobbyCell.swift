//
//  LobbyCell.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyCell: UICollectionViewCell {

    // MARK: Members

    static let identifier = "LobbyCell"

    // MARK: IBOutlets
    
    @IBOutlet weak var levelNumber: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!

    // MARK: UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeZero
    }

    override func prepareForReuse() {
        firstStar.image = UIImage(named: "NoStar")
        secondStar.image = UIImage(named: "NoStar")
        thirdStar.image = UIImage(named: "NoStar")
        levelNumber.text = "0"
    }
}
