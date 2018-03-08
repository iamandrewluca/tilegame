//
//  Helpers.swift
//  TileGame
//
//  Created by Andrei Luca on 17/04/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: Operator overloading

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

func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}

func ==(lhs: (row: Int, column: Int), rhs: (row: Int, column: Int)) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}

// MARK: Other useful functions

func clamp(firstValue: CGFloat, _ secondValue: CGFloat, _ value: CGFloat) -> CGFloat {

    var minValue: CGFloat
    var maxValue: CGFloat

    if firstValue > secondValue {
        maxValue = firstValue
        minValue = secondValue
    } else {
        maxValue = secondValue
        minValue = firstValue
    }

    return max(minValue, min(value, maxValue))
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
        i -= 1;
    }
    return points
}

func getStarPath(x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, pointyness: CGFloat) -> CGPathRef {
    let adjustment = 360/sides/2
    let path = CGPathCreateMutable()
    let points = polygonPointArray(sides, x: x, y: y, radius: radius)
    let cpg = points[0]
    let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
    var i = 0
    CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
    for p in points {
        CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
        CGPathAddLineToPoint(path, nil, p.x, p.y)
        i += 1
    }
    CGPathCloseSubpath(path)

    var rotaionTransform = CGAffineTransformMakeRotation(degree2radian(-54))
    return CGPathCreateCopyByTransformingPath(path, &rotaionTransform)!
}

// MARK: Extensions

extension CGFloat {
    mutating func roundDecimals(numberOfDecimals: Int) {
        let multiplier = pow(10.0, CGFloat(numberOfDecimals))
        self = round(self * multiplier) / multiplier
    }
}

extension SKLabelNode {
    func setTextWithinSize(text: String, size: CGFloat, vertically: Bool) {
        self.text = text

        if vertically {
            self.fontSize *= size / self.frame.height
        } else {
            self.fontSize *= size / self.frame.width
        }
    }
}