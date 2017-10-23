//
//  Sizer.swift
//  helptometro
//
//  Created by Андрей Илалов on 22.10.2017.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//
// class for creating raws up and down, means up size and down size - n/m, n - up, m - down
import Foundation



class Sizer {
    var type: String
    var element: Int
    init(type: String, element: Int) {
        self.type = type
        self.element = element
    }
    
    func nextElement() -> Int {
        if self.type == "down" && element < 64{
                element *= 2
        }
        else if self.type == "up" && element < 64{
                element += 1
        }
    return element
    }
    
    func previousElement() -> Int {
        if self.type == "down" && element > 1{
                element /= 2
        }
        else if self.type == "up" && element > 1{
                element -= 1
        }
        return element
    }
    
}
