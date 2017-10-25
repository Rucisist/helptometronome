//
//  TapViewController.swift
//  helptometro
//
//  Created by Андрей Илалов on 25.10.2017.
//  Copyright © 2017 Андрей Илалов. All rights reserved.
//

import UIKit

class TapViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer!
    var numberOfTapps: Int = 0
    var date: Date!
    var elapsedTime:CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapped(_ sender: Any){
        timeLabel.text = String(round(60/(CFAbsoluteTimeGetCurrent() - elapsedTime)))
        elapsedTime = CFAbsoluteTimeGetCurrent()
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
