//
//  ViewController.swift
//  helptometro
//
//  Created by Андрей Илалов on 22.10.2017.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    var sizeUp = Sizer(type: "up", element: 4)
    var sizeDown = Sizer(type: "down", element: 4)
    var valueOnSlider: Int!
    
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBAction func vchange(_ sender: Any) {
        guard (timer != nil) else {
            return
        }
        label1.text = String(changer.value)
        timer?.invalidate()
        timerStart()
        
        
    }
    enum metroi {
        case left,right
    }
    var timer: Timer?
    var time: Double!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var changer: UISlider!
    
    
    @IBAction func plusOrMinusClickUp(_ sender: UIButton){
        let buttonType = sender.titleLabel?.text! ?? "+"
        sizeUp.element = Int(upLabel.text!) ?? 4
        
        switch buttonType {
        case "+":
           upLabel.text = String(sizeUp.nextElement())
            
        case "-":
            upLabel.text = String(sizeUp.previousElement())
            
        default:
            print(buttonType)
        }
        
        guard (timer != nil) else {
            return
        }
        timer?.invalidate()
        timerStart()
        label1.text = String(changer.value)
    }
    
    @IBAction func plusOrMinusClickDown(_ sender: UIButton){
        let buttonType = sender.titleLabel?.text! ?? "+"
        sizeDown.element = Int(downLabel.text!) ?? 4
        
        switch buttonType {
        case "+":
            downLabel.text = String(sizeDown.nextElement())
            
        case "-":
            downLabel.text = String(sizeDown.previousElement())
            
        default:
            print(buttonType)
        }
        
        guard (timer != nil) else {
            return
        }
        timer?.invalidate()
        timerStart()
        label1.text = String(changer.value)
    }
    
    
    @IBAction func plusOrMinusClick(_ sender: UIButton){
    //print(sender.titleLabel?.text)
        
        let buttonType = sender.titleLabel?.text! ?? "+"
        switch buttonType {
        case "+":
            changer.value += 1
            
        case "-":
            changer.value -= 1

        default:
            print(buttonType)
        }
        
        guard (timer != nil) else {
            return
        }
        timer?.invalidate()
        timerStart()
        label1.text = String(changer.value)
    }
    
    
    func timerStart() {
        var m: metroi
        m = .left
        time = 0.0
        
        var audioPlayer: AVAudioPlayer!
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sdown", ofType: "wav")!)
        
        try!  audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer.prepareToPlay()
        var lTick = 0.0
        let timeInterval = 0.01
        
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true) { timer in
            
            self.valueOnSlider = Int(self.changer.value)
            let elapsedTime:CFAbsoluteTime = CFAbsoluteTimeGetCurrent() - lTick
            let tempo = Double(self.valueOnSlider)
            let downNumber = Double(self.downLabel.text!)!
            let targetTime = 60.0 / (tempo / (4.0 / downNumber))
            print(targetTime)
            //60  / (темп / ( 4 / знаменатель размера ))
            
            if (elapsedTime > targetTime) || (abs(elapsedTime - targetTime) < 0.001) {
                lTick = CFAbsoluteTimeGetCurrent()
                audioPlayer.stop()
                audioPlayer.play()
            }
            
            
            self.time = self.time + (0.1 * 1/targetTime)
            if self.time >= 1{
                if m == .left{
                    self.metrImage.image = UIImage(named: "right1.png")
                    m = .right
                }
                else{
                    self.metrImage.image = UIImage(named: "left.png")
                    m = .left
                }
                self.time = 0.0
            }
        }
    }
    
    
    @IBAction func change(_ sender: Any) {
        
        timerStart()
        label1.text = String(changer.value)

    }
    @IBOutlet weak var metrImage: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changer.maximumValue = 240.0
        changer.minimumValue = 1.0
        changer.value = 120.0
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

