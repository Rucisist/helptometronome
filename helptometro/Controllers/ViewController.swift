//
//  ViewController.swift
//  helptometro
//
//  Created by Андрей Илалов on 22.10.2017.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//icons by freepic and noun

import UIKit
import AVFoundation

class ViewController: UIViewController {
    enum metroi {
        case left,right
    }
    var timer: Timer?
    var time: Double!
    var sizeUp = Sizer(type: "up", element: 4)
    var sizeDown = Sizer(type: "down", element: 4)
    var valueOnSlider: Int!
    var startedMetronome = false
    let metronome = Metronome()
    var timerForImage: Timer?
    var m: metroi = .left
    
    
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var enhancedModeTmblr: UISwitch!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    
    
    @IBAction func vchange(_ sender: Any) {
        label1.text = String(Int((changer.value)))
        if !startedMetronome{
        guard (timer != nil) else {
            return
        }
        timer?.invalidate()
            
        }
        else{
            if !enhancedModeTmblr.isOn {
                timer?.invalidate()
                timerStart()
            }
            if enhancedModeTmblr.isOn{
                stopAndStartEnhancedMetronomeWithP()
            }
        }
        
        
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var changer: UISlider!
    
    @IBAction func enhancedModeTmblrCjanged(_ sender: Any) {
        timer?.invalidate()
        metronome.stop()
        timerForImage?.invalidate()
        startedMetronome = false
        startButton.backgroundColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(1))
        startButton.tintColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(200), alpha: CGFloat(1))
        startButton.setTitle("start", for: .normal)
    }
    
    
    @IBAction func plusOrMinusClick(_ sender: UIButton){
        label1.text = String(Int((changer.value)))
        let buttonType = sender.titleLabel?.text! ?? "+"
        let buttonIndex = sender.tag
        switch buttonIndex {
        case 1:
            changer.value += 1
            
        case 2:
            changer.value -= 1
        case 3:

            upLabel.text = String(sizeUp.nextElement())
            
        case 4:
            upLabel.text = String(sizeUp.previousElement())
            
        case 5:
            downLabel.text = String(sizeDown.nextElement())
            
        case 6:
            downLabel.text = String(sizeDown.previousElement())

        default:
            print(buttonType)
        }
        
 approveInStartAndStopIfNeed()
    }
    
    

    
    @IBAction func change(_ sender: Any) {

        if !startedMetronome {
            startButton.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(255), alpha: CGFloat(0.1))
            startButton.tintColor = UIColor(red: CGFloat(255), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.6))
             startButton.setTitle("stop", for: .normal)
            
        }
        else {
            startButton.backgroundColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(1))
            startButton.tintColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(200), alpha: CGFloat(1))
             startButton.setTitle("start", for: .normal)
        }
       stateMetronome()
        //startedMetronome = false
    }
    
 
    @IBOutlet weak var metrImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changer.maximumValue = 240.0
        changer.minimumValue = 1.0
        changer.value = 120.0
        label1.text = String(Int(changer.value))
        startButton.tintColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(200), alpha: CGFloat(1))
        startButton.layer.cornerRadius = 4
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func timerStart() {
        time = 0.0
        
        var audioPlayer: AVAudioPlayer!
        guard Bundle.main.path(forResource: "sdown", ofType: "wav") != nil else {
            return
        }
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sdown", ofType: "wav")!)

        try!  audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer.prepareToPlay()
        var lTick = 0.0
        let timeInterval = 0.01
        let upNumb = Int(upLabel.text!)!
        var copyUpNumb = upNumb
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true) { timer in
            
            self.valueOnSlider = Int(self.changer.value)
            let elapsedTime:CFAbsoluteTime = CFAbsoluteTimeGetCurrent() - lTick
            let tempo = Double(self.valueOnSlider)
            let downNumber = Double(self.downLabel.text!)!
            let targetTime = 60.0 / (tempo / (4.0 / downNumber))
            //60  / (темп / ( 4 / знаменатель размера ))
            //make tick according to date with accurate 0.001
            if (elapsedTime > targetTime) || (abs(elapsedTime - targetTime) < 0.001) {
                lTick = CFAbsoluteTimeGetCurrent()
                
                //every n times make a volume level up to create a strong note
                copyUpNumb = copyUpNumb - 1
                if copyUpNumb == 0{
                    audioPlayer.volume = 10
                    copyUpNumb = upNumb
                }
                else{
                    audioPlayer.volume = 1
                }
                audioPlayer.stop()
                audioPlayer.play()
                
            }
            
            //animate image
            self.time = self.time + (timeInterval)
            if self.time >= targetTime{
                if self.m == .left{
                    self.metrImage.image = UIImage(named: "right1.png")
                    self.m = .right
                }
                else{
                    self.metrImage.image = UIImage(named: "left.png")
                    self.m = .left
                }
                self.time = 0.0
            }
        }
    }
    
    
    
    
    func imageAnimate() {
        timerForImage = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){timer in
            
            if self.m == .left{
                self.metrImage.image = UIImage(named: "right1.png")
                self.m = .right
            }
            else{
                self.metrImage.image = UIImage(named: "left.png")
                self.m = .left
            }
        }
    }
    //to set the right metronome state
    func stateMetronome() {
        if !startedMetronome{
            if !enhancedModeTmblr.isOn {
                timerStart()
            }
            if enhancedModeTmblr.isOn{
                startEnhancedMetronomeWithParameters()
            }
            
            startedMetronome = true
        }
        else if startedMetronome {
            if !enhancedModeTmblr.isOn {
                timer?.invalidate()
            }
            if enhancedModeTmblr.isOn{
                metronome.stop()
                timerForImage?.invalidate()
            }
            startedMetronome = false
            
        }
        
    }
    
    func stopAndStartEnhancedMetronomeWithP(){
        stopOfEnhancedMetronome()
        startEnhancedMetronomeWithParameters()
    }
    
    func stopOfEnhancedMetronome(){
        metronome.stop()
        timerForImage?.invalidate()
    }
    
    func startEnhancedMetronomeWithParameters(){
        
        metronome.uSize = Int(upLabel.text!)!
        let dNum = Int(downLabel.text!)
        let Tempo = changer.value * Float(dNum!)/4
        metronome.Tempo = Tempo
        metronome.start()
        imageAnimate()
    }
    
    
    func approveInStartAndStopIfNeed(){
        if startedMetronome{
            if !enhancedModeTmblr.isOn{
                
                guard (timer != nil) else {
                    return
                }
                timer?.invalidate()
                timerStart()
            }
            else {
                stopAndStartEnhancedMetronomeWithP()
            }
        }
        else {
            if !enhancedModeTmblr.isOn{
                
                guard (timer != nil) else {
                    return
                }
                timer?.invalidate()
            }
            else {
                stopOfEnhancedMetronome()
            }
        }
    }
    

}

