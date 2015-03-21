//
//  Shape.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-21.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, Printable {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue:Int(arc4random_uniform(NumOrientations)))!
    }
    
// #1
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1: -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue:rotated)!
    }
}

// The number of total shape varieties
let NumShapeTypes: UInt32 = 7

// Shape indexes
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, Printable {
   
    let color:BlockColor // color of the shape
    
    var blocks = Array<Block>() // The blocks comprising the shape

    var orientation: Orientation // current orientation of the shape

    var column, row:Int   // The column and row representing the shape's anchor point
    
    // Required Overrides
    // #1  Subclasses must override this property - dictionary with key:value
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]  // returns empty values so subclasses can provide data
    }
    // #2  Subclasses must override this property
    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }
    // #3 complete computed property
    var bottomBlocks:Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[orientation] {
            return bottomBlocks
        }
        return []
    }

    var hashValue:Int {  // Hashable
        // #4  this method iterates through entire block array
        return reduce(blocks, 0) { $0.hashValue ^ $1.hashValue }
    }
    
    var description:String {    // Printable
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column:Int, row:Int, color: BlockColor, orientation:Orientation) {
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    // #5 a special initializer
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    // #6 final func cannot be overridden by subclasses
    final func initializeBlocks() {
    // #7 conditional: if no array, if block is not executed
    if let blockRowColumnTranslations = blockRowColumnPositions[orientation] {
        for i in 0..<blockRowColumnTranslations.count {
            let blockRow = row + blockRowColumnTranslations[i].rowDiff
            let blockColumn = column + blockRowColumnTranslations[i].columnDiff
            let newBlock = Block(column: blockColumn, row: blockRow, color: color)
            blocks.append(newBlock)
        }
    }
}

}

func ==(lhs: Shape, rhs: Shape) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}















