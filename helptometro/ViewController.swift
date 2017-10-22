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
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var enhancedModeTmblr: UISwitch!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    var sizeUp = Sizer(type: "up", element: 4)
    var sizeDown = Sizer(type: "down", element: 4)
    var valueOnSlider: Int!
    var startedMetronome = false
    let metronome = Metronome()
    
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    @IBAction func vchange(_ sender: Any) {
        label1.text = String(Int((changer.value)))
        guard (timer != nil) else {
            return
        }
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
    
    @IBAction func enhancedModeTmblrCjanged(_ sender: Any) {
        timer?.invalidate()
        metronome.stop()
        startedMetronome = false
        startButton.backgroundColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(0.5))
        startButton.titleLabel?.text = "start"
//        if enhancedModeTmblr.isOn{
//            metronome.start()
//        }
    }
    
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
    }
    
    
    @IBAction func plusOrMinusClick(_ sender: UIButton){
    //print(sender.titleLabel?.text)
        label1.text = String(Int((changer.value)))
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
    }
    
    
    func timerStart() {
        var m: metroi
        m = .left
        time = 0.0
        
        var audioPlayer: AVAudioPlayer!
        var audioPlayerUp: AVAudioPlayer!
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "sdown", ofType: "wav")!)
        let alertSoundUp = URL(fileURLWithPath: Bundle.main.path(forResource: "sup", ofType: "wav")!)
        try!  audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        try! audioPlayerUp = AVAudioPlayer(contentsOf: alertSoundUp)
        audioPlayer.prepareToPlay()
        audioPlayerUp.prepareToPlay()
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
            
            if (elapsedTime > targetTime) || (abs(elapsedTime - targetTime) < 0.001) {
                lTick = CFAbsoluteTimeGetCurrent()
                copyUpNumb = copyUpNumb - 1
                if copyUpNumb == 0{
                    audioPlayerUp.play()
                    copyUpNumb = upNumb
                }
                else{
                    audioPlayer.stop()
                    audioPlayer.play()
                }
                
                
            }
            
            
            self.time = self.time + (timeInterval)
            if self.time >= targetTime{
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
       stateMetronome()
    }
    
    func stateMetronome() {
        if !startedMetronome{
            if !enhancedModeTmblr.isOn {
                timerStart()
            }
            if enhancedModeTmblr.isOn{
                startEnhancedMetronomeWithParameters()
            }
            startButton.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(255), alpha: CGFloat(0.5))
            startButton.titleLabel?.text = "stop"
            startedMetronome = true
        }
        else if startedMetronome {
            if !enhancedModeTmblr.isOn {
                timer?.invalidate()
            }
            if enhancedModeTmblr.isOn{
                metronome.stop()
            }
            startedMetronome = false
            startButton.backgroundColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: CGFloat(0.5))
            startButton.titleLabel?.text = "start"
        }
        
    }
    
    func startEnhancedMetronomeWithParameters(){

        metronome.uSize = Int(upLabel.text!)!
        let dNum = Int(downLabel.text!)
        let Tempo = changer.value * Float(dNum!)/4
        metronome.Tempo = Tempo
        metronome.start()
    }
    
    
    @IBOutlet weak var metrImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changer.maximumValue = 240.0
        changer.minimumValue = 1.0
        changer.value = 120.0
        label1.text = String(Int(changer.value))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

