//
//  GameViewController.swift
//  Breakout
//
//  Created by Chris Lu on 10/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameView: UIView!
    
    lazy var dynamicAnimator:UIDynamicAnimator = {
        let lazyinstance = UIDynamicAnimator(referenceView: self.gameView)
        return lazyinstance
    }()
    
    @IBAction func randomPush(sender: UITapGestureRecognizer) {
        ballBehavior.activeRandomPush()
    }
    
    let ballBehavior = BallBehavior()
    
    var ballSize: CGSize {
        let diameter = 20
        return CGSize(width: diameter, height: diameter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator.addBehavior(ballBehavior)

        newBall()
    }
    
    //add new ball to game
    private func newBall() {
        var frame = CGRect(origin: CGPointZero, size: ballSize)
        frame.origin.x = gameView.bounds.size.width / 2
        frame.origin.y = gameView.bounds.size.height / 2
        let ballView = UIView(frame: frame)
        ballView.backgroundColor = UIColor.blueColor()
        ballBehavior.addBall(ballView)
    }

}
