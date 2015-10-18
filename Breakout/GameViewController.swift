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
    
    @IBAction func movePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(gameView)
            let horizontalMove = translation.x
            if ((paddleRect.center.x - CGFloat(paddleHalfWidth)) + horizontalMove) >= 0 && ((paddleRect.center.x + CGFloat(paddleHalfWidth)) + horizontalMove) <= gameView.bounds.size.width {
                paddleRect.center.x += horizontalMove
            }
            sender.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
    }
    
    @IBAction func randomPush(sender: UITapGestureRecognizer) {
        ballBehavior.activeRandomPush()
    }
    
    let ballBehavior = BallBehavior()
    
    var ballSize: CGSize {
        let diameter = 10
        return CGSize(width: diameter, height: diameter)
    }
    
    let paddleHalfWidth = 40
    
    var paddleSize: CGSize {
        return CGSize(width: paddleHalfWidth*2, height: 10)
    }
    
    var paddleRect: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator.addBehavior(ballBehavior)
        
        //draw paddle
        var frame = CGRect(origin: CGPointZero, size: paddleSize)
        frame.origin.x = gameView.bounds.size.width / 2
        frame.origin.y = (gameView.bounds.size.height * 2) / 3
        paddleRect = UIView(frame: frame)
        paddleRect.backgroundColor = UIColor.blackColor()
        gameView.addSubview(paddleRect)
        
        //one ball to start with
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
