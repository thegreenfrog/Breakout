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
        static let RowsKey = "Settings.Rows"
        static let BallsKey = "Settings.Balls"
        static let DifficultyKey = "Settings.Difficulty"
        static let SpeedKey = "Settings.Speed"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var row: Int? {
        get { return defaults.objectForKey(Constants.RowsKey) as? Int }
        set { defaults.setObject(newValue, forKey: Constants.RowsKey) }
    }
    
    var balls: Int? {
        get { return defaults.objectForKey(Constants.BallsKey) as? Int }
        set { defaults.setObject(newValue, forKey: Constants.BallsKey) }
    }
    
    var speed: Float {
        get {return defaults.objectForKey(Constants.SpeedKey) as? Float ?? 1.0 }
        set { defaults.setObject(newValue, forKey: Constants.SpeedKey) }
    }
}