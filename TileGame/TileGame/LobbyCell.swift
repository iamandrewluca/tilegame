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

        layer.cornerRadius = Board.tileCornerRadius
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeZero

        backgroundColor = Constants.cellBackgroundColor
        levelNumber.textColor = Constants.textColor
        firstStar.tintColor = Constants.noStarColor
        secondStar.tintColor = Constants.noStarColor
        thirdStar.tintColor = Constants.noStarColor
    }

    override func prepareForReuse() {
        firstStar.tintColor = Constants.noStarColor
        secondStar.tintColor = Constants.noStarColor
        thirdStar.tintColor = Constants.noStarColor
        levelNumber.text = "0"
    }
}
