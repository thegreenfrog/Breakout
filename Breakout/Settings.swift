//
//  Settings.swift
//  Breakout
//
//  Created by Chris Lu on 10/23/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import Foundation

class Setting {
    
    private struct Constants {
        static let RowsKey = "Setting.Rows"
        static let BallsKey = "Setting.Balls"
        static let AutoStartKey = "Settings.AutoStart"
        static let SpeedKey = "Setting.Speed"
        static let ChangedKey = "Setting.Changed"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var row: Int {
        get { return defaults.objectForKey(Constants.RowsKey) as? Int ?? 5 }
        set { defaults.setObject(newValue, forKey: Constants.RowsKey) }
    }
    
    var balls: Int {
        get { return defaults.objectForKey(Constants.BallsKey) as? Int ?? 1 }
        set { defaults.setObject(newValue, forKey: Constants.BallsKey) }
    }
    
    var speed: Float {
        get {return defaults.objectForKey(Constants.SpeedKey) as? Float ?? 1.0 }
        set { defaults.setObject(newValue, forKey: Constants.SpeedKey) }
    }
    
    var Changed: Bool {
        get { return defaults.objectForKey(Constants.ChangedKey) as? Bool ?? false}
        set { defaults.setObject(newValue, forKey: Constants.ChangedKey) }
    }
    
    var autoStart: Bool {
        get { return defaults.objectForKey(Constants.AutoStartKey) as? Bool ?? false}
        set { defaults.setObject(newValue, forKey: Constants.AutoStartKey) }
    }
    
    convenience init(defaultRow: Int, defaultBalls: Int, defaultSpeed: Float) {
        self.init()
        print("\(defaultRow), \(defaultBalls)")
        row = defaultRow
        balls = defaultBalls
        speed = defaultSpeed
        Changed = false
        autoStart = false
    }
}