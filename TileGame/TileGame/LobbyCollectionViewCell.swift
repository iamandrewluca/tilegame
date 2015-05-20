//
//  LobbyCollectionViewCell.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        
        layer.cornerRadius = 10
        
        backgroundColor = UIColor.whiteColor()
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeZero
    }
}
