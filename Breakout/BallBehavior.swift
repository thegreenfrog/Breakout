//
//  ballBehavior.swift
//  Breakout
//
//  Created by Chris Lu on 10/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class BallBehavior: UIDynamicBehavior
{
    var collisionDelegate: UICollisionBehaviorDelegate? {
        get { return collider.collisionDelegate }
        set { collider.collisionDelegate = newValue }
    }
    
    let gravity = UIGravityBehavior()
    
    //collision for wall, paddle, and bricks
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        lazilyCreatedCollider.action = {
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                    self.removeBall(ball)
                }
            }
        }
        return lazilyCreatedCollider
    }()
    
    lazy var objectBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = false
        lazilyCreatedDropBehavior.resistance = 0
        lazilyCreatedDropBehavior.friction = 0
        lazilyCreatedDropBehavior.elasticity = 1
        return lazilyCreatedDropBehavior
        }()
    
    var balls:[UIView] {
        get {
            return collider.items.filter{$0 is UIView}.map{$0 as! UIView}
        }
    }
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(objectBehavior)
    }
    
    func pauseAnimation() {
        for ball in balls {
            ball.layer.speed = 0
            ball.layer.timeOffset = ball.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        }
    }
    
    func addBarrier(path: UIBezierPath, named name: NSCopying) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(name: NSCopying) {
        collider.removeBoundaryWithIdentifier(name)
        //need to remove this subview too
    }
    
    func removeBrick(index: Int, view: UIView) {
        gravity.addItem(view)
        removeBarrier(index)
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        objectBehavior.addItem(ball)
        collider.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        objectBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func activeRandomPush(ball: UIView, magnitude: Float) {
        let push = UIPushBehavior(items: [ball], mode: .Instantaneous)
        push.magnitude = CGFloat(0.1 * magnitude)
        
        push.angle = CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
        push.action = { [weak push] in
            if !push!.active {
                self.removeChildBehavior(push!)
            }
        }
        addChildBehavior(push)
    }
}
