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
    var headerSize = CGSizeMake(0, Tile.tileLength)
    var sectionSize = CGSize.zeroSize
    
    var numberOfColumns: Int = 2
    var spacing: CGFloat = 0
    var rowsPerSection = 0
    var collectionWidth = Constants.screenSize.width
    
    var layoutInfo: [String : [NSIndexPath : UICollectionViewLayoutAttributes]]!

    var isLayoutPrepared = false

    // MARK: LobbyLayout

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        if Constants.isIphone {
            numberOfColumns = 2
        } else {
            numberOfColumns = 3
        }
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
//        var rowCount = rowsPerSection * collectionView!.numberOfSections()
//
//        var headersHeight = CGFloat(collectionView!.numberOfSections()) * (headerSize.height + headerInsets.top + headerInsets.bottom + spacing)
//
//        var cellsHeight = CGFloat(rowCount) * (cellSize.height + cellInsets.top + cellInsets.bottom + spacing)
//
//        var height = headersHeight + cellsHeight

        var oneSectionFrame = frameForSection(0)
        oneSectionFrame.size.height *= CGFloat(collectionView!.numberOfSections())

        return oneSectionFrame.size

//        return CGSizeMake(collectionWidth, height)
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

        frame.origin.y -= sectionInsets.top
        frame.size.height += sectionInsets.top

        frame.size.height += sectionInsets.bottom

        return frame
    }

    func createHeaderLayoutAttributes() {

        var headerLayoutInfo = [NSIndexPath : UICollectionViewLayoutAttributes]()

        for i in 0..<collectionView!.numberOfSections() {

            var indexPath = NSIndexPath(forItem: 0, inSection: i)

            var attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LobbyHeader.identifier, withIndexPath: indexPath)

            var sectionFrame = frameForSection(i)


            let minimumY = max(collectionView!.contentOffset.y + collectionView!.contentInset.top, sectionFrame.origin.y)
            let maximumY = CGRectGetMaxY(sectionFrame) - headerSize.height - collectionView!.contentInset.bottom

            attributes.frame = CGRectMake(0, min(minimumY, maximumY), collectionWidth, headerSize.height)
            attributes.zIndex = 1

            headerLayoutInfo[indexPath] = attributes
        }

        layoutInfo[LobbyHeader.identifier] = headerLayoutInfo
    }

    func createCellLayoutAttributes() {
        headerSize.width = collectionWidth
        rowsPerSection = collectionView!.numberOfItemsInSection(0) / numberOfColumns

        spacing = collectionWidth + cellInsets.left -
            CGFloat(numberOfColumns) * (cellSize.width + cellInsets.right + cellInsets.left)

        spacing = spacing / CGFloat(numberOfColumns + 1)

        var newLayoutInfo = [String : [NSIndexPath : UICollectionViewLayoutAttributes]]()
        var cellLayoutInfo = [NSIndexPath : UICollectionViewLayoutAttributes]()
        var headerLayoutInfo = [NSIndexPath : UICollectionViewLayoutAttributes]()

        var sectionCount = collectionView?.numberOfSections()
        var indexPath: NSIndexPath!

        for var section = 0; section < sectionCount; ++section {
            var itemCount = collectionView!.numberOfItemsInSection(section)

            for var item = 0; item < itemCount; ++item {
                indexPath = NSIndexPath(forItem: item, inSection: section)

                if indexPath.item == 0 {
                    var headerAttributes = UICollectionViewLayoutAttributes(
                        forSupplementaryViewOfKind: LobbyHeader.identifier, withIndexPath: indexPath)

                    headerAttributes.frame = frameForHeaderAtIndexPath(indexPath)
                    headerLayoutInfo[indexPath] = headerAttributes
                }

                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                itemAttributes.frame = frameForCellAtIndexPath(indexPath)

                cellLayoutInfo[indexPath] = itemAttributes
            }
        }

        newLayoutInfo[LobbyCell.identifier] = cellLayoutInfo
        newLayoutInfo[LobbyHeader.identifier] = headerLayoutInfo
        layoutInfo = newLayoutInfo
    }
    
    func frameForHeaderAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var headerFrame = CGRectZero
        headerFrame.size = headerSize
        
        headerFrame.origin.y = CGFloat(indexPath.section) * (headerSize.height + spacing + CGFloat(rowsPerSection) * (cellSize.height + spacing))
        
        return headerFrame
    }
    
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        
        var rowInSection = indexPath.item / numberOfColumns
        var columnInSection = indexPath.item % numberOfColumns
        
        var cellFrame = frameForHeaderAtIndexPath(indexPath)
        cellFrame.size = cellSize
        
        cellFrame.origin.x = spacing + CGFloat(columnInSection) * (cellSize.width + spacing)
        cellFrame.origin.y += headerSize.height + spacing + CGFloat(rowInSection) * (cellSize.height + spacing)
        
        return cellFrame
    }
}