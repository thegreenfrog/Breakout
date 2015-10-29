//
//  SettingsViewController.swift
//  Breakout
//
//  Created by Chris Lu on 10/23/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var rowNumDisplay: UILabel!
    @IBOutlet weak var rowNumSlider: UISlider!
    @IBOutlet weak var ballNumDisplay: UILabel!
    @IBOutlet weak var speedPercent: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var ballStepper: UIStepper!

    
    @IBAction func rowNumChanged(sender: UISlider) {
        rows = Int(sender.value)
        //print("Setting row: \(Int(sender.value))")
        Setting.Changed = true
    }
    
    @IBAction func ballNumChanged(sender: UIStepper) {
        ballNum = Int(sender.value)
        Setting.balls = ballNum
        Setting.Changed = true
        if ballNum > 1 {
            Setting.autoStart = true
        }
    }
    
    @IBAction func speedChanged(sender: UISlider) {
        print(sender.value)
        speed = sender.value
        Setting.speed = speed
        Setting.Changed = true
    }
    
    var rows: Int {
        get {
            return Int(Setting.row)
        }
        set {
            //print(newValue)
            rowNumDisplay.text = "\(newValue)"
            Setting.row = newValue
            print("new row setting: \(Setting.row)")
            //rowNumSlider.value = Float(newValue)
        }
    }
    
    var ballNum: Int {
        get {
            return Int(ballNumDisplay.text!)!
        }
        set {
            ballNumDisplay.text = "\(newValue)"
            ballStepper.value = Double(newValue)
        }
    }
    
    var speed: Float {
        get {
            return Float(Setting.speed)
        }
        set {
            print("set speed: \(newValue)")
            speedPercent.text = "\(Int(newValue * 100)) %"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rows = Setting.row
        rowNumSlider.maximumValue = Float(10)
        rowNumSlider.setValue(Float(rows), animated: true)
        ballNum = Setting.balls
        speed = Setting.speed
        speedSlider.maximumValue = Float(1)
        //print(speed)
        speedSlider.setValue(speed, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
