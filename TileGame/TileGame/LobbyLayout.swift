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

    // MARK: Members
    
    var cellInsets = UIEdgeInsetsZero
    var headerInsets = UIEdgeInsetsZero
    var sectionInsets = UIEdgeInsetsZero
    
    var cellSize = CGSizeMake(145, 145)
    var headerSize = CGSizeMake(Constants.screenSize.width, Tile.tileLength)
    var sectionSize = CGSize.zeroSize
    
    var columnsPerSection: CGFloat = 2.0
    var rowsPerSection: CGFloat = 3.0
    var spacingBetweenCells: CGFloat = 0.0
    var collectionWidth = Constants.screenSize.width
    
    var layoutInfo = [String : [NSIndexPath : UICollectionViewLayoutAttributes]]()

    var isLayoutPrepared = false

    // MARK: LobbyLayout

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        if Constants.isIphone {
            columnsPerSection = 2.0
            rowsPerSection = 3.0
        } else {
            columnsPerSection = 3.0
            rowsPerSection = 2.0
        }

        println(collectionWidth)

//        if collectionWidth < 321 {
//            cellSize = CGSize(width: 135, height: 135)
//        }

        spacingBetweenCells = (collectionWidth - columnsPerSection * cellSize.width) / (columnsPerSection + 1)

        sectionSize.width = collectionWidth
        sectionSize.height = headerSize.height + spacingBetweenCells + rowsPerSection * (spacingBetweenCells + cellSize.height)
    }

    // MARK: UICollectionViewLayout
    
    override func prepareLayout() {

        super.prepareLayout()

        if !isLayoutPrepared {
            isLayoutPrepared = true

            createCellLayoutAttributes()
        }

        createHeaderLayoutAttributes()
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {

        var allAttributes = [UICollectionViewLayoutAttributes]()

        for (elementIdentifier, elementsInfo) in layoutInfo {
            for (indexPath, attributes) in elementsInfo {
                if rect.intersects(attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
        }

        return allAttributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return layoutInfo[LobbyCell.identifier]![indexPath]
    }

    override func collectionViewContentSize() -> CGSize {
        var collectionSize = sectionSize
        collectionSize.height *= CGFloat(collectionView!.numberOfSections())
        return collectionSize
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {

        var attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)

        if elementKind == LobbyHeader.identifier {
            attributes = layoutInfo[LobbyHeader.identifier]![indexPath]
        }

        return attributes
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: Methods

    func frameForSection(section: Int) -> CGRect {

        var firstIndexPath = NSIndexPath(forItem: 0, inSection: section)
        var lastIndexPath = NSIndexPath(forItem: 5, inSection: section)

        var firstCellTop = layoutAttributesForItemAtIndexPath(firstIndexPath).frame.origin.y
        var lastCellBottom = CGRectGetMaxY(layoutAttributesForItemAtIndexPath(lastIndexPath).frame)

        var frame = CGRectZero
        frame.size.width = collectionWidth
        frame.origin.y = firstCellTop
        frame.size.height = lastCellBottom - firstCellTop

        frame.origin.y -= headerSize.height
        frame.size.height += headerSize.height

        frame.origin.y -= spacingBetweenCells
        frame.size.height += spacingBetweenCells

        frame.size.height += spacingBetweenCells

        return frame
    }

    func createHeaderLayoutAttributes() {

        var headerLayoutInfo = [NSIndexPath : UICollectionViewLayoutAttributes]()

        for i in 0..<collectionView!.numberOfSections() {

            var indexPath = NSIndexPath(forItem: 0, inSection: i)

            var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LobbyHeader.identifier, withIndexPath: indexPath)

            var sectionFrame = frameForSection(i)

            let minimumY = max(collectionView!.contentOffset.y, sectionFrame.origin.y)
            let maximumY = CGRectGetMaxY(sectionFrame) - headerSize.height

            attributes.frame = CGRectMake(0, min(minimumY, maximumY), collectionWidth, headerSize.height)
            attributes.zIndex = 1

            headerLayoutInfo[indexPath] = attributes
        }

        layoutInfo[LobbyHeader.identifier] = headerLayoutInfo

    }

    func createCellLayoutAttributes() {

        var cellLayoutInfo = [NSIndexPath : UICollectionViewLayoutAttributes]()

        var sectionCount = collectionView!.numberOfSections()
        var indexPath: NSIndexPath!

        for section in 0..<sectionCount {
            var itemCount = collectionView!.numberOfItemsInSection(section)

            for item in 0..<itemCount {
                indexPath = NSIndexPath(forItem: item, inSection: section)

                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = frameForCellAtIndexPath(indexPath)

                cellLayoutInfo[indexPath] = itemAttributes
            }
        }

        layoutInfo[LobbyCell.identifier] = cellLayoutInfo
    }
    
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var rowInSection = CGFloat(indexPath.item / Int(columnsPerSection))
        var columnInSection = CGFloat(indexPath.item % Int(columnsPerSection))
        
        var cellFrame = CGRect(origin: CGPoint.zeroPoint, size: cellSize)
        
        cellFrame.origin.x = spacingBetweenCells + columnInSection * (cellSize.width + spacingBetweenCells)

        // add lower sections height
        cellFrame.origin.y = CGFloat(indexPath.section) *
            (headerSize.height + spacingBetweenCells + rowsPerSection * (cellSize.height + spacingBetweenCells))

        cellFrame.origin.y += headerSize.height + spacingBetweenCells
        cellFrame.origin.y += (cellSize.height + spacingBetweenCells) * rowInSection
        
        return cellFrame
    }
}