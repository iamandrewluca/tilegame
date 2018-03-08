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
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
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

func clamp(_ firstValue: CGFloat, _ secondValue: CGFloat, _ value: CGFloat) -> CGFloat {

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

func degree2radian(_ a:CGFloat) -> CGFloat {
    let b = CGFloat(Double.pi) * a/180
    return b
}

private func polygonPointArray(_ sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
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

func getStarPath(_ x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, pointyness: CGFloat) -> CGPath {
    let adjustment = 360/sides/2
    let path = CGMutablePath()
    let points = polygonPointArray(sides, x: x, y: y, radius: radius)
    let cpg = points[0]
    let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
    var i = 0
    path.move(to: cpg)
    for p in points {
        path.addLine(to: points2[i])
        path.addLine(to: p)
        i += 1
    }
    path.closeSubpath()

    var rotaionTransform = CGAffineTransform(rotationAngle: degree2radian(-54))
    return path.copy(using: &rotaionTransform)!
}

// MARK: Extensions

extension CGFloat {
    mutating func roundDecimals(_ numberOfDecimals: Int) {
        let multiplier = pow(10.0, CGFloat(numberOfDecimals))
        self = Foundation.round(self * multiplier) / multiplier
    }
}

extension SKLabelNode {
    func setTextWithinSize(_ text: String, size: CGFloat, vertically: Bool) {
        self.text = text

        if vertically {
            self.fontSize *= size / self.frame.height
        } else {
            self.fontSize *= size / self.frame.width
        }
    }
}
