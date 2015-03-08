//
//  GameScene.swift
//  Space Shooter
//
//  Created by rukesh on 3/4/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//  Sounds from SoundBible.com:  explosion:  Mike Koenig
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let backgroundStarNode = SKNode()
    let foregroundNode = SKNode()
    let player = SKNode()
    
    //convience properties
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        //background
        backgroundColor = SKColor.blackColor()
        physicsWorld.contactDelegate = self
        backgroundStarNode = createBackgroundStar()
        addChild(backgroundStarNode)
        for index in 0...20 {
            let starNode = createStarForScreenSize(height, width: width)
            var nodeChildren = starNode.children
            backgroundStarNode.addChild(starNode)
            //TODO add physics to stars!
        }
        
        
        //foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)
        let asteriodA = createAsteriodForScreenSize(UIScreen.mainScreen().bounds.size.height, width: UIScreen.mainScreen().bounds.size.width, ofType: .Small)
        foregroundNode.addChild(asteriodA)

        //player
        player = createPlayer()
        foregroundNode.addChild(player)
        }


    
    func createBackgroundStar()-> SKNode{
        let backgroundStarNode = SKNode()
        for index in 0...10 {
            let node = SKSpriteNode(imageNamed: "starbackground5.png")
            node.position = CGPoint(x:0, y: index * 250)
            node.name = "ASTERIOD"
            backgroundStarNode.addChild(node)
        }
        return backgroundStarNode
    }
    func createPlayer()->SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width/2, y: 80)
        let sprite = SKSpriteNode(imageNamed: "Spaceship")
        sprite.setScale(0.15)
        playerNode.addChild(sprite)
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Asteriod
        return playerNode
    }
    
    func createStarForScreenSize(height: CGFloat, width: CGFloat) -> StarNode {
        let node = StarNode()
        let thePosition = CGPoint(x: CGFloat(arc4random()) % width, y: CGFloat(arc4random()) % height)
        node.position = thePosition
        node.name = "NODE_STAR"
        var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "star1.png")
        node.setScale(0.05)
        node.addChild(sprite)
                //node.physicsBody?.velocity.dy = ((CGFloat(arc4random() % 2)) == 0) ? 5 : 1
        return node
    }
    
    func createAsteriodForScreenSize(height: CGFloat, width: CGFloat, ofType type: AsteriodType) -> asteriodNode {
        let node = asteriodNode()
        let thePosition = CGPoint(x: CGFloat(arc4random()) % width, y: CGFloat(arc4random()) % height)
        println("position = \(thePosition)")
        node.position = thePosition
        node.name = "NODE_ASTERIOD"
        var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "asteriod3.png")
        node.asteriodType = type
        if type == .Big {
                node.setScale(0.15)
        } else if type == .Medium {
            node.setScale(0.10)
        } else {
            node.setScale(0.05)
        }
        node.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
        node.physicsBody?.dynamic = true
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.friction = 0.0
        node.physicsBody?.angularDamping = 0.0
        node.physicsBody?.linearDamping = 0.0
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.angularVelocity = (CGFloat(arc4random()) % 8)/2 - 2
        node.physicsBody?.velocity = (CGVector(dx: CGFloat(arc4random()) % 80 - 40, dy: CGFloat(arc4random()) % 40 * -1))
        node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Asteriod
        node.physicsBody?.collisionBitMask = 0
        node.addChild(sprite)
        return node
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var updateHUD = false
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as GameObjectNode
        updateHUD = other.collisionWithPlayer(player)
        if updateHUD {
            //TODO
        }
    }
}

/*
let x = CGFloat(arc4random()) % UIScreen.mainScreen().bounds.size.width
let y = CGFloat(arc4random()) % UIScreen.mainScreen().bounds.size.height
node.size = CGSize(width: 20, height: 20)
node.position = CGPoint(x:x,y:y)
node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2)
node.physicsBody?.dynamic = true
node.physicsBody?.restitution = 1.0
node.physicsBody?.friction = 0.0
node.physicsBody?.angularDamping = 0.0
node.physicsBody?.linearDamping = 0.0
node.physicsBody?.affectedByGravity = false
node.physicsBody?.velocity = (CGVector(dx: 0, dy: CGFloat(arc4random())%10 * -1))
//TODO:  remove collisions
*/
