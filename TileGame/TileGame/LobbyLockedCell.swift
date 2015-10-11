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
        layer.cornerRadius = Tile.tileCornerRadius * 2
        layer.masksToBounds = false
    }



}
