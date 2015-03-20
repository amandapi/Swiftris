//
//  block.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-20.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import SpriteKit

// #1
let NumberOfColors: UInt32 = 6

// #2 the enum is of type Int and implements the Printable protocol
enum BlockColor: Int, Printable {
    
// #3  blue at 0 ... yellow at 5
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
// #4  declare computed property spriteName which returns the correct filename for given color
    var spriteName: String {
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
        }
    }

// #5  declare computed property description required bu Printable protocol
    var description: String {
        return self.spriteName
    }
    
// #6  random func returning 0 ... 5
    static func random() -> BlockColor {
        return BlockColor(rawValue:Int(arc4random_uniform(NumberOfColors)))!
    }
}

// #7  implements both protocols Hashable (can be stored in Array2D) and Printable (human readable)
class Block: Hashable, Printable {
    
// #8  constants
    let color: BlockColor
    
// #9  properties
    var column: Int  // location of block
    var row: Int  // location of block
    var sprite: SKSpriteNode?  // so GameScene can use Block
    
// #10  shortens block.color.spriteName to block.spriteName
    var spriteName: String {
        return color.spriteName
    }
    
// #11  required by Hashable protocol
    var hashValue: Int {  // return an int representing row and column properties
        return self.column ^ self.row
    }
    
// #12  required by Printable protocol
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}

// #13  returns true only if both blocks are in same location and of same color. This is required by Hashable protocol
func == (lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
}


