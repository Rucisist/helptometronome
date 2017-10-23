//
//  Colorimetr.swift
//  helptometro
//
//  Created by Андрей Илалов on 23.10.2017.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//
//creating color, based on temp

import UIKit


class Colorimetr{
    let startPoint: Double
    let endPoint: Double
    init(startPoint: Double, endPoint: Double) {
        self.startPoint = startPoint //did not use it, it is for extensions
        self.endPoint = endPoint
    }
    
    func giveMeColor(Tempo: Double) -> UIColor{
        let redColor = CGFloat((Tempo/endPoint))
        let blueColor = CGFloat((1-Tempo/endPoint))
        var greenColor = CGFloat(0)
        if Tempo < 120{
            greenColor = CGFloat(Tempo/endPoint)}
        else{
            greenColor = CGFloat(1-Tempo/endPoint)
        }
        return UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
    }
    
}
