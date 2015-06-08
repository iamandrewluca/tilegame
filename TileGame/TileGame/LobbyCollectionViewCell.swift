//
//  LobbyCollectionViewCell.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var levelNumber: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
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
