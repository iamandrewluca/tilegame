//
//  LobbyLockedCell.swift
//  TileGame
//
//  Created by Andrei Luca on 6/10/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyLockedCell: UICollectionViewCell {

    // MARK: Members


    static let identifier: String = "LobbyLockedCell"


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



}
