//
//  Helpers.swift
//  TileGame
//
//  Created by Andrei Luca on 17/04/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x - rhs.x, lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPointMake(lhs.x + rhs.x, lhs.y + rhs.y)
}

func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPointMake(lhs.x / rhs, lhs.y / rhs)
}

func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func !=(lhs: CGPoint, rhs: CGPoint) -> Bool {
    return lhs.x != rhs.x && lhs.y != rhs.y
}

func clamp(minLimit: CGFloat, maxLimit: CGFloat, value: CGFloat) -> CGFloat {
    return max(minLimit, min(value, maxLimit))
}

extension CGFloat {
    mutating func roundDecimals(numberOfDecimals: Int) {
        let multiplier = pow(10.0, CGFloat(numberOfDecimals))
        self = round(self * multiplier) / multiplier
    }
}

func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    var multipliedSize = lhs
    multipliedSize.width *= rhs
    multipliedSize.height *= rhs
    return multipliedSize
}

func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    var dividedSize = lhs
    dividedSize.width /= rhs
    dividedSize.height /= rhs
    return dividedSize
}

func degree2radian(a:CGFloat) -> CGFloat {
    let b = CGFloat(M_PI) * a/180
    return b
}

private func polygonPointArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
    let angle = degree2radian(360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = sides
    var points = [CGPoint]()
    while points.count <= sides {
        let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
        let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
        points.append(CGPoint(x: xpo, y: ypo))
        i--;
    }
    return points
}
func getStarPath(x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, pointyness: CGFloat) -> CGPathRef {
    let adjustment = 360/sides/2
    let path = CGPathCreateMutable()
    let points = polygonPointArray(sides, x, y, radius)
    var cpg = points[0]
    let points2 = polygonPointArray(sides,x,y,radius*pointyness,adjustment:CGFloat(adjustment))
    var i = 0
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
        CGPathAddLineToPoint(path, nil, p.x, p.y)
        i++
    }
    CGPathCloseSubpath(path)

    var rotaionTransform = CGAffineTransformMakeRotation(degree2radian(-54))
    return CGPathCreateCopyByTransformingPath(path, &rotaionTransform)
}