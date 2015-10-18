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
            paddleRect.frame.origin.x = max(min(paddleRect.frame.origin.x + horizontalMove, gameView.bounds.maxX - paddleSize.width), 0.0)
            let newPaddle = UIBezierPath(rect: paddleRect.frame)
            ballBehavior.addBarrier(newPaddle, named: "paddle")
            sender.setTranslation(CGPointZero, inView: gameView)
        default: break
        }
    }
    
    @IBAction func randomPush(sender: UITapGestureRecognizer) {
        ballBehavior.activeRandomPush(ballBehavior.balls.last!)
    }
    
    let ballBehavior = BallBehavior()
    
    var ballSize: CGSize {
        let diameter = 10
        return CGSize(width: diameter, height: diameter)
    }
    var paddleSize: CGSize {
        return CGSize(width: 80, height: 10)
    }
    
    lazy var paddleRect: UIView = {
        //draw paddle
        var frame = CGRect(origin: CGPointZero, size: self.paddleSize)
        frame.origin.x = self.gameView.bounds.midX
        frame.origin.y = (self.gameView.bounds.size.height * 9) / 10
        let paddleRect = UIView(frame: frame)
        paddleRect.backgroundColor = UIColor.blackColor()
        return paddleRect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamicAnimator.addBehavior(ballBehavior)
        gameView.addSubview(paddleRect)
        //one ball to start with
        newBall()
    }
    
    //add new ball to game
    private func newBall() {
        var frame = CGRect(origin: CGPointZero, size: ballSize)
        frame.origin.x = gameView.bounds.midX
        frame.origin.y = gameView.bounds.midY
        let ballView = UIView(frame: frame)
        ballView.backgroundColor = UIColor.blueColor()
        ballBehavior.addBall(ballView)
    }

}
