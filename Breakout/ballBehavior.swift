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
    
    //collision for wall, paddle, and bricks
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
        }()
    
    lazy var objectBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = true
        lazilyCreatedDropBehavior.elasticity = 1
        return lazilyCreatedDropBehavior
        }()
    
    //handle the randomp push on the ball
    lazy var randomPushBehavior: UIPushBehavior = {
        let lazilyCreatedRandomPush = UIPushBehavior(items: [], mode: UIPushBehaviorMode.Instantaneous)
        lazilyCreatedRandomPush.pushDirection = CGVector(dx: (Double(arc4random()%20) * 0.01), dy: (Double(arc4random()%20) * 0.01))
        lazilyCreatedRandomPush.active = false
        return lazilyCreatedRandomPush
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(objectBehavior)
        addChildBehavior(randomPushBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func removeBarrier(name: String) {
        collider.removeBoundaryWithIdentifier(name)
        //need to remove this subview too
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        randomPushBehavior.addItem(ball)//NEES TO BE DYANMIC ITEM
        collider.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func activeRandomPush() {
        randomPushBehavior.active = true;
    }
}
