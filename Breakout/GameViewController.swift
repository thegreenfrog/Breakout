//
//  GameViewController.swift
//  Breakout
//
//  Created by Chris Lu on 10/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var gameView: UIView!
    
    // MARK: - Animation
    
    lazy var dynamicAnimator:UIDynamicAnimator = {
        let lazyinstance = UIDynamicAnimator(referenceView: self.gameView)
        return lazyinstance
    }()
    
    var ballBehavior = BallBehavior()
    
    var autoStartTimer: NSTimer?
    
    // MARK: - Gestures
    
    func movePaddle(sender: UIPanGestureRecognizer) {
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
    
    func randomPush(sender: UITapGestureRecognizer) {
        if ballNum < maxBallNum {
            newBall()
            return
        }
        for ball in ballBehavior.balls {
            ballBehavior.activeRandomPush(ball, magnitude: speedRatio)
        }
        
    }
    
    // MARK: - Object Specs
    var speedRatio = Float(0.5)
    var brickRows = 5
    
    private var ballNum = 0
    private var maxBallNum = 1
    
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
    
    var bricks = [Int: Brick]()
    
    private var bricksDestroyed = 0
    
    struct Brick {
        var Frame: CGRect
        var viewInstance: UIView
        var hitPoints: Int
    }
    
    struct Constants {
        static let BrickColumns = 10
        static let BrickTotalWidth: CGFloat = 1.0
        static let BrickProportionHeight: CGFloat = 0.04
        static let BrickTopSpacing: CGFloat = 0.05
        static let BrickSpacing: CGFloat = 5.0
        static let BrickCornerRadius: CGFloat = 2.5
        static let BrickColors = [UIColor.greenColor(), UIColor.blueColor(), UIColor.redColor(), UIColor.yellowColor()]
        
        static let PauseString = "Pause"
        static let ResumeString = "Resume"
    }
    
    func togglePause(sender: UIButton) {
        print("\(sender.titleLabel!.text)")
        if sender.titleLabel!.text! == Constants.PauseString {
            print("stopping")
            sender.setTitle(Constants.ResumeString, forState: .Normal)
        } else if sender.titleLabel!.text! == Constants.ResumeString {
            print("resuming")
            sender.setTitle(Constants.PauseString, forState: .Normal)
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ballBehavior.collisionDelegate = self
        Setting(defaultRow: brickRows, defaultBalls: 1, defaultSpeed: speedRatio)
        drawBricks()
        print("bricks: \(bricks.count)")
        dynamicAnimator.addBehavior(ballBehavior)
        gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "randomPush:"))
        gameView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "movePaddle:"))
    }
    
    override func viewDidLayoutSubviews() {
        gameView.addSubview(paddleRect)
        //create bricks
        setBrickBoundaries()
    }
    
    override func viewDidAppear(animated: Bool) {
        //change game configuration if settings have changed
        setAutoStartTimer()
        if Setting.Changed == true {
            Setting.Changed = false
            maxBallNum = Setting.balls
            brickRows = Setting.row
            speedRatio = Setting.speed
            for (_, brick) in bricks {
                brick.viewInstance.removeFromSuperview()
            }
            for ball in ballBehavior.balls {
                ball.removeFromSuperview()
            }
            bricks.removeAll(keepCapacity: true)
            dynamicAnimator.removeAllBehaviors()
            ballBehavior = BallBehavior()
            dynamicAnimator.addBehavior(ballBehavior)
            ballBehavior.collisionDelegate = self
            ballNum = 0
            bricksDestroyed = 0
            drawBricks()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        autoStartTimer?.invalidate()
        autoStartTimer = nil
    }
    
    func setAutoStartTimer() {
        if Setting.autoStart {
            autoStartTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "autoStart:", userInfo: nil, repeats: true)
        }
    }
    
    func autoStart(timer: NSTimer) {
        if ballNum < maxBallNum {
            newBall()
        }
    }
    
    func restartGame() {
        for (_, brick) in bricks {
            brick.viewInstance.removeFromSuperview()
        }
        for ball in ballBehavior.balls {
            ball.removeFromSuperview()
        }
        bricks.removeAll(keepCapacity: true)
        dynamicAnimator.removeAllBehaviors()
        ballBehavior = BallBehavior()
        dynamicAnimator.addBehavior(ballBehavior)
        ballBehavior.collisionDelegate = self

        ballNum = 0
        bricksDestroyed = 0
        gameView.addSubview(paddleRect)
        setBrickBoundaries()
        drawBricks()
    }
    
    // MARK: - Brick Methods
    
    private func drawBricks() {
        //only add if first starting up or restarting
        if bricks.count > 0 {return}
        print("number of rows: \(brickRows)")
        let heightProportion = Constants.BrickProportionHeight
        let widthProportion = Constants.BrickTotalWidth / CGFloat(Constants.BrickColumns)
        var frame = CGRect(origin: CGPointZero, size: CGSize(width: widthProportion, height: heightProportion))
        for row in 0..<brickRows {
            for col in 0..<Constants.BrickColumns {
                frame.origin.x = widthProportion * CGFloat(col)
                frame.origin.y = heightProportion * CGFloat(row) + Constants.BrickTopSpacing
                let brickView = UIView(frame: frame)
                brickView.layer.cornerRadius = Constants.BrickCornerRadius
                brickView.layer.borderColor = UIColor.blackColor().CGColor
                brickView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                brickView.layer.shadowOpacity = 0.1
                
                //generate random type of brick
                let type = Int(arc4random() % 3)
                brickView.backgroundColor = Constants.BrickColors[type]
                gameView.addSubview(brickView)
                bricks[row * Constants.BrickColumns + col] = Brick(Frame: frame, viewInstance: brickView, hitPoints: type + 1)
            }
        }
    }
    
    private func setBrickBoundaries() {
        for (index, brick) in bricks {
            brick.viewInstance.frame.origin.x = brick.Frame.origin.x * gameView.bounds.width
            brick.viewInstance.frame.origin.y = brick.Frame.origin.y * gameView.bounds.height
            brick.viewInstance.frame.size.width = brick.Frame.width * gameView.bounds.width
            brick.viewInstance.frame.size.height = brick.Frame.height * gameView.bounds.height
            brick.viewInstance.frame = CGRectInset(brick.viewInstance.frame, Constants.BrickSpacing, Constants.BrickSpacing)
            ballBehavior.addBarrier(UIBezierPath(roundedRect: brick.viewInstance.frame, cornerRadius: Constants.BrickCornerRadius), named: index)
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if let index = identifier as? Int {
            removeBrick(index)
        } else if p.y > paddleRect.frame.origin.y {
            //ball has gone below the paddle
            for object in ballBehavior.balls {
                if object.isEqual(item) {
//                    ballBehavior.removeBall(object)
//                    ballNum--
                }
            }
            
        }
    }
    
    private func removeBrick(index: Int) {
        if let brick = bricks[index] {
            if brick.hitPoints == 0 {
                bricks.removeValueForKey(index)
                ballBehavior.removeBrick(index, view: brick.viewInstance)
                bricksDestroyed++
            }
            else {
//                let snap = UISnapBehavior(item: ballBehavior.collider.items[index], snapToPoint: brick.Frame.origin)
//                dynamicAnimator.addBehavior(snap)
                bricks[index]!.hitPoints--
            }
           
        }
        //check if user has destroyed all bricks
        if bricks.count == 0 {
            print("destoryed: \(bricksDestroyed) bricks total: \(bricks.count)")
            let alert = UIAlertController(title: "You've won!", message: "Would you like to play again?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(
                title: "Yes",
                style: UIAlertActionStyle.Default)
                { (action: UIAlertAction) -> Void in
                    self.restartGame()
                }
            )
            alert.addAction(UIAlertAction(
                title: "No",
                style: .Destructive)
                { (action: UIAlertAction) -> Void in
                    print("Game Over")
                }
            )
            alert.addAction(UIAlertAction(
                title: "Cancel",
                style: .Cancel)
                { (action: UIAlertAction) -> Void in
                    
                }
            )
            
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - Ball Action
    //add new ball to game
    private func newBall() {
        var frame = CGRect(origin: CGPointZero, size: ballSize)
        frame.origin.x = gameView.bounds.midX
        frame.origin.y = gameView.bounds.midY
        let ballView = UIView(frame: frame)
        ballView.backgroundColor = UIColor.blueColor()
        ballBehavior.addBall(ballView)
        ballNum++
        if Setting.autoStart {
            ballBehavior.activeRandomPush(ballView, magnitude: speedRatio)
        }
    }

}
