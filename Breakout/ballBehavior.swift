//
//  ballBehavior.swift
//  Breakout
//
//  Created by Chris Lu on 10/16/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit

class ballBehavior: UIDynamicBehavior
{
    let gravity = UIGravityBehavior()
    
    //collision for wall, paddle, and bricks
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
        }()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedDropBehavior = UIDynamicItemBehavior()
        lazilyCreatedDropBehavior.allowsRotation = true
        lazilyCreatedDropBehavior.elasticity = 1
        return lazilyCreatedDropBehavior
        }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
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
        collider.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        ball.removeFromSuperview()
    }
}
