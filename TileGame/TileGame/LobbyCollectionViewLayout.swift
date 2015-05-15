//
//  LobbyCollectionViewLayout.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import UIKit

class LobbyCollectionViewLayout : UICollectionViewLayout {
    
    var itemInsets: UIEdgeInsets
    var itemSize: CGSize
    var numberOfColumns: Int
    var interItemSpacingY: CGFloat
    let cellIdentifier = "Cell"
    
    var layoutInfo = Dictionary<String, Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>>()

    required init(coder aDecoder: NSCoder) {
        
        itemInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        itemSize = CGSizeMake(145, 145)
        interItemSpacingY = 10
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            numberOfColumns = 3
        } else {
            numberOfColumns = 2
        }

        super.init(coder: aDecoder)
    }
    
    override func prepareLayout() {
        
        var newLayoutInfo = Dictionary<String, Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>>()
        var cellLayoutInfo = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
        var sectionCount = collectionView?.numberOfSections()
        var indexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        for var section = 0; section < sectionCount; ++section {
            var itemCount = collectionView?.numberOfItemsInSection(section)
            
            for var item = 0; item < itemCount; ++item {
                indexPath = NSIndexPath(forItem: item, inSection: section)

                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = frameForItemAtIndexPath(indexPath)
                
                cellLayoutInfo[indexPath] = itemAttributes
            }
        }
        
        newLayoutInfo[cellIdentifier] = cellLayoutInfo
        layoutInfo = newLayoutInfo
    }
    
    func frameForItemAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var rowPerSection = collectionView!.numberOfItemsInSection(indexPath.section) / numberOfColumns
        
        var row = indexPath.item / numberOfColumns + indexPath.section * rowPerSection
        
        var column = indexPath.item % numberOfColumns
        
        var spacingX: CGFloat = collectionView!.bounds.size.width + itemInsets.left -
            CGFloat(numberOfColumns) * (itemSize.width + itemInsets.right + itemInsets.left)
        
        var spacingXpart: CGFloat = spacingX / CGFloat(numberOfColumns + 1)
        
        var originX: CGFloat = floor(spacingXpart + itemInsets.left + CGFloat(column) * (itemSize.width + spacingXpart + itemInsets.right))
        var originY: CGFloat = floor(itemInsets.top + CGFloat(row) * (itemSize.height + interItemSpacingY))
        
        return CGRectMake(originX, originY, itemSize.width, itemSize.height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var allAttributes = Array<UICollectionViewLayoutAttributes>()
        
        for (elementIdentifier, elementsInfo) in layoutInfo {
            for (indexPath, attributes) in elementsInfo {
                if CGRectIntersectsRect(rect, attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
        }

        return allAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return layoutInfo[cellIdentifier]![indexPath]
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        var rowPerSection = collectionView!.numberOfItemsInSection(0) / numberOfColumns
        var rowCount = rowPerSection * collectionView!.numberOfSections()
        var height = itemInsets.top + CGFloat(rowCount) * itemSize.height + CGFloat(rowCount - 1) * interItemSpacingY + itemInsets.bottom
        
        return CGSizeMake(collectionView!.bounds.size.width, height)
    }
}