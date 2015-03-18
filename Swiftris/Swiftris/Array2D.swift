//
//  Array2D.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-18.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

// #1 define class Array2D
class Array2D<T> {  //<T> is a typed parameter for storage
    let columns: Int
    let rows: Int
    
// #2 declare an actual Swift array
    var array: Array<T?>  // ? is an optional value, OK to be nil
    
    init(columns: Int, rows:Int) {
        self.columns = columns
        self.rows = rows
        
// #3 instantiate array with size rows*columns, ie, 200 here
        array = Array<T?>(count:rows * columns, repeatedValue: nil)
    }

// #4 create a subscript capable of suppporting array[column, row]
    subscript(column: Int, row: Int) -> T? {
        get {   // getter
            return array[(row * columns) + column]
        }
        set(newValue) {   // setter
            array[(row * columns) + column] = newValue
        }
    }
}
