//
//  LobbyLayout.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import UIKit

class LobbyLayout : UICollectionViewLayout {
    
    var cellInsets = UIEdgeInsetsZero
    var headerInsets = UIEdgeInsetsZero
    
    var cellSize = CGSizeMake(145, 145)
    var headerSize = CGSizeMake(0, 48)
    
    var numberOfColumns: Int
    var spacingX: CGFloat = 0
    var spacingY: CGFloat = 0
    var rowsPerSection = 0
    
    var layoutInfo: Dictionary<String, Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>>!

    required init(coder aDecoder: NSCoder) {
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            numberOfColumns = 3
        } else {
            numberOfColumns = 2
        }
        
        super.init(coder: aDecoder)
    }
    
    override func prepareLayout() {
        
        headerSize.width = collectionView!.bounds.width
        rowsPerSection = collectionView!.numberOfItemsInSection(0) / numberOfColumns
        
        spacingX = collectionView!.bounds.size.width + cellInsets.left -
            CGFloat(numberOfColumns) * (cellSize.width + cellInsets.right + cellInsets.left)
        
        spacingX = spacingX / CGFloat(numberOfColumns + 1)
        spacingY = spacingX
        
        var newLayoutInfo = Dictionary<String, Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>>()
        var cellLayoutInfo = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
        var headerLayoutInfo = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
        
        var sectionCount = collectionView?.numberOfSections()
        var indexPath: NSIndexPath!
        
        for var section = 0; section < sectionCount; ++section {
            var itemCount = collectionView!.numberOfItemsInSection(section)
            
            for var item = 0; item < itemCount; ++item {
                indexPath = NSIndexPath(forItem: item, inSection: section)
                
                if indexPath.item == 0 {
                    var headerAttributes = UICollectionViewLayoutAttributes(
                        forSupplementaryViewOfKind: Identifiers.lobbyHeader, withIndexPath: indexPath)
                    
                    headerAttributes.frame = frameForHeaderAtIndexPath(indexPath)
                    headerLayoutInfo[indexPath] = headerAttributes
                }

                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = frameForCellAtIndexPath(indexPath)
                
                cellLayoutInfo[indexPath] = itemAttributes
            }
        }
        
        newLayoutInfo[Identifiers.lobbyCell] = cellLayoutInfo
        newLayoutInfo[Identifiers.lobbyHeader] = headerLayoutInfo
        layoutInfo = newLayoutInfo
    }
    
    func frameForHeaderAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var headerFrame = CGRectZero
        headerFrame.size = headerSize
        
        headerFrame.origin.y = CGFloat(indexPath.section) * (headerSize.height + spacingY + CGFloat(rowsPerSection) * (cellSize.height + spacingY))
        
        return headerFrame
    }
    
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var rowInSection = indexPath.item / numberOfColumns
        var columnInSection = indexPath.item % numberOfColumns
        
        var cellFrame = frameForHeaderAtIndexPath(indexPath)
        cellFrame.size = cellSize
        
        cellFrame.origin.x = spacingX + CGFloat(columnInSection) * (cellSize.width + spacingX)
        cellFrame.origin.y += headerSize.height + spacingY + CGFloat(rowInSection) * (cellSize.height + spacingY)
        
        return cellFrame
//        var originX: CGFloat = floor(spacingX + cellInsets.left + CGFloat(column) * (cellSize.width + spacingX + cellInsets.right))
//        
//        var headersTotalHeight: CGFloat = (headerSize.height + headerInsets.bottom) + CGFloat(indexPath.section) * (headerSize.height + headerInsets.top + headerInsets.bottom)
//        
//        var cellsTotalHeight: CGFloat = CGFloat(row) * (cellSize.height + cellInsets.top + cellInsets.bottom + spacingY)
//    
//        var originY: CGFloat = floor(headersTotalHeight + spacingY + cellInsets.top + cellsTotalHeight)
//        
//        return CGRectMake(originX, originY, cellSize.width, cellSize.height)
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
        return layoutInfo[Identifiers.lobbyCell]![indexPath]
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        var rowCount = rowsPerSection * collectionView!.numberOfSections()
        
        var headersHeight = CGFloat(collectionView!.numberOfSections()) * (headerSize.height + headerInsets.top + headerInsets.bottom + spacingY)
        
        var cellsHeight = CGFloat(rowCount) * (cellSize.height + cellInsets.top + cellInsets.bottom + spacingY)
        
        var height = headersHeight + cellsHeight
        
        return CGSizeMake(collectionView!.bounds.size.width, height)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        var attribute: UICollectionViewLayoutAttributes!
        
        if elementKind == Identifiers.lobbyHeader {
            attribute = layoutInfo[Identifiers.lobbyHeader]![indexPath]
        }
        
        return attribute
    }
}