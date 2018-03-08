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
    
    var cellInsets = UIEdgeInsets.zero
    var headerInsets = UIEdgeInsets.zero
    var sectionInsets = UIEdgeInsets.zero
    
    var cellSize = CGSize(width: 145, height: 145)
    var headerSize = CGSize(width: Constants.screenSize.width, height: Tile.tileLength)
    var sectionSize = CGSize.zero
    
    var columnsPerSection: CGFloat = 2.0
    var rowsPerSection: CGFloat = 3.0
    var spacingBetweenCells: CGFloat = 0.0
    var collectionWidth = Constants.screenSize.width
    
    var layoutInfo = [String : [IndexPath : UICollectionViewLayoutAttributes]]()

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

        layoutInfo[LobbyHeader.identifier] = [IndexPath : UICollectionViewLayoutAttributes]()
        layoutInfo[LobbyCell.identifier] = [IndexPath : UICollectionViewLayoutAttributes]()
    }

    // MARK: UICollectionViewLayout
    
    override func prepare() {

        super.prepare()

        createCellLayoutAttributes()

        createHeaderLayoutAttributes()

    }

    override var collectionViewContentSize : CGSize {
        var collectionSize = sectionSize
        collectionSize.height *= CGFloat(collectionView!.numberOfSections)
        return collectionSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

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

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfo[LobbyCell.identifier]![indexPath]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        var attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)

        if elementKind == LobbyHeader.identifier {
            attributes = layoutInfo[LobbyHeader.identifier]![indexPath]
        }

        return attributes
    }

    // MARK: Methods

    func frameForSection(_ section: Int) -> CGRect {

        let firstIndexPath = IndexPath(item: 0, section: section)
        let lastIndexPath = IndexPath(item: 5, section: section)

        let firstCellTop = layoutAttributesForItem(at: firstIndexPath)!.frame.origin.y
        let lastCellBottom = layoutAttributesForItem(at: lastIndexPath)!.frame.maxY

        var frame = CGRect.zero
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

        let sectionCount = collectionView!.numberOfSections
        var indexPath: IndexPath!

        for section in (0 ... sectionCount - 1).reversed() {
            let itemCount = 6

            for item in (0 ... itemCount - 1).reversed() {
                indexPath = IndexPath(item: item, section: section)

                if layoutInfo[LobbyCell.identifier]![indexPath] == nil {
                    layoutInfo[LobbyCell.identifier]![indexPath] = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    layoutInfo[LobbyCell.identifier]![indexPath]?.frame = frameForCellAtIndexPath(indexPath)
                } else {
                    return
                }
            }
        }
    }

    func createHeaderLayoutAttributes() {

        for i in 0 ..< collectionView!.numberOfSections {

            let indexPath = IndexPath(item: 0, section: i)

            if layoutInfo[LobbyHeader.identifier]![indexPath] == nil {
                layoutInfo[LobbyHeader.identifier]![indexPath] = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: LobbyHeader.identifier, with: indexPath)
            }

            let attributes = layoutInfo[LobbyHeader.identifier]![indexPath]!

            let sectionFrame = frameForSection(i)

            let minimumY = max(collectionView!.contentOffset.y, sectionFrame.origin.y)
            let maximumY = sectionFrame.maxY - headerSize.height

            attributes.frame = CGRect(x: 0, y: min(minimumY, maximumY), width: collectionWidth, height: headerSize.height)
            attributes.zIndex = 1
        }
    }
    
    func frameForCellAtIndexPath(_ indexPath: IndexPath) -> CGRect {
        
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
