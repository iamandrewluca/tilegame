//
//  LobbyLayout.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import UIKit

// TODO: should calculate frames on the fly
// in case of many levels, will be a lot of frames
class LobbyLayout : UICollectionViewLayout {

    // MARK: Members
    
    var cellInsets = UIEdgeInsetsZero
    var headerInsets = UIEdgeInsetsZero
    var sectionInsets = UIEdgeInsetsZero
    
    var cellSize = CGSizeMake(145, 145)
    var headerSize = CGSizeMake(Constants.screenSize.width, Tile.tileLength)
    var sectionSize = CGSize.zero
    
    var columnsPerSection: CGFloat = 2.0
    var rowsPerSection: CGFloat = 3.0
    var spacingBetweenCells: CGFloat = 0.0
    var collectionWidth = Constants.screenSize.width
    
    var layoutInfo = [String : [NSIndexPath : UICollectionViewLayoutAttributes]]()

    // MARK: LobbyLayout

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        if Constants.isIphone {
            columnsPerSection = 2.0
            rowsPerSection = 3.0
        } else {
            columnsPerSection = 3.0
            rowsPerSection = 2.0
        }

        if collectionWidth >= 768 {
            cellSize = CGSize(width: 165, height: 165)
        } else if collectionWidth <= 320 {
            cellSize = CGSize(width: 125, height: 125)
        }

        spacingBetweenCells = (collectionWidth - columnsPerSection * cellSize.width) / (columnsPerSection + 1)

        sectionSize.width = collectionWidth
        sectionSize.height = headerSize.height + spacingBetweenCells + rowsPerSection * (spacingBetweenCells + cellSize.height)

        layoutInfo[LobbyHeader.identifier] = [NSIndexPath : UICollectionViewLayoutAttributes]()
        layoutInfo[LobbyCell.identifier] = [NSIndexPath : UICollectionViewLayoutAttributes]()
    }

    // MARK: UICollectionViewLayout
    
    override func prepareLayout() {

        super.prepareLayout()

        createCellLayoutAttributes()

        createHeaderLayoutAttributes()

    }

    override func collectionViewContentSize() -> CGSize {
        var collectionSize = sectionSize
        collectionSize.height *= CGFloat(collectionView!.numberOfSections())
        return collectionSize
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var allAttributes = [UICollectionViewLayoutAttributes]()

        for (_, elementsInfo) in layoutInfo {
            for (_, attributes) in elementsInfo {
                if rect.intersects(attributes.frame) {
                    allAttributes.append(attributes)
                }
            }
        }

        return allAttributes
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfo[LobbyCell.identifier]![indexPath]
    }

    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        var attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)

        if elementKind == LobbyHeader.identifier {
            attributes = layoutInfo[LobbyHeader.identifier]![indexPath]
        }

        return attributes
    }

    // MARK: Methods

    func frameForSection(section: Int) -> CGRect {

        let firstIndexPath = NSIndexPath(forItem: 0, inSection: section)
        let lastIndexPath = NSIndexPath(forItem: 5, inSection: section)

        let firstCellTop = layoutAttributesForItemAtIndexPath(firstIndexPath)!.frame.origin.y
        let lastCellBottom = CGRectGetMaxY(layoutAttributesForItemAtIndexPath(lastIndexPath)!.frame)

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

    func createCellLayoutAttributes() {

        let sectionCount = collectionView!.numberOfSections()
        var indexPath: NSIndexPath!

        for section in (0 ... sectionCount - 1).reverse() {
            let itemCount = 6

            for item in (0 ... itemCount - 1).reverse() {
                indexPath = NSIndexPath(forItem: item, inSection: section)

                if layoutInfo[LobbyCell.identifier]![indexPath] == nil {
                    layoutInfo[LobbyCell.identifier]![indexPath] = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    layoutInfo[LobbyCell.identifier]![indexPath]?.frame = frameForCellAtIndexPath(indexPath)
                } else {
                    return
                }
            }
        }
    }

    func createHeaderLayoutAttributes() {

        for i in 0 ..< collectionView!.numberOfSections() {

            let indexPath = NSIndexPath(forItem: 0, inSection: i)

            if layoutInfo[LobbyHeader.identifier]![indexPath] == nil {
                layoutInfo[LobbyHeader.identifier]![indexPath] = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LobbyHeader.identifier, withIndexPath: indexPath)
            }

            let attributes = layoutInfo[LobbyHeader.identifier]![indexPath]!

            let sectionFrame = frameForSection(i)

            let minimumY = max(collectionView!.contentOffset.y, sectionFrame.origin.y)
            let maximumY = CGRectGetMaxY(sectionFrame) - headerSize.height

            attributes.frame = CGRectMake(0, min(minimumY, maximumY), collectionWidth, headerSize.height)
            attributes.zIndex = 1
        }
    }
    
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        let rowInSection = CGFloat(indexPath.item / Int(columnsPerSection))
        let columnInSection = CGFloat(indexPath.item % Int(columnsPerSection))
        
        var cellFrame = CGRect(origin: CGPoint.zero, size: cellSize)
        
        cellFrame.origin.x = spacingBetweenCells + columnInSection * (cellSize.width + spacingBetweenCells)

        // add lower sections height
        cellFrame.origin.y = CGFloat(indexPath.section) *
            (headerSize.height + spacingBetweenCells + rowsPerSection * (cellSize.height + spacingBetweenCells))

        cellFrame.origin.y += headerSize.height + spacingBetweenCells
        cellFrame.origin.y += (cellSize.height + spacingBetweenCells) * rowInSection
        
        return cellFrame
    }
}