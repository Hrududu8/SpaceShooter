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
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    let backgroundStarNode = SKNode()
    let foregroundNode = SKNode()
    let player = SKNode()
    let motionManager = CMMotionManager()
    var xAccel  : CGFloat = 0.0
    var yAccel : CGFloat = 0.0
    
    //convience properties
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        //background
        backgroundColor = SKColor.blackColor()
        physicsWorld.contactDelegate = self
        backgroundStarNode = createBackgroundStar()
        
        
        //foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)

        //add asteriods
        var arrayOfAsteriods = [asteriodNode]()
        for index in 0...19 {
            let asteriodA = createAsteriodForScreenSize(screenHeight, width: screenWidth, ofType: .Small)
            arrayOfAsteriods.append(asteriodA)
            foregroundNode.addChild(asteriodA)
            }
        self.setAsteriodProperties(arrayOfAsteriods)
        
        //player
        player = createPlayer()
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        player.physicsBody?.dynamic = true
        player.physicsBody?.velocity.dx = 100.0
        foregroundNode.addChild(player)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: {(acceleromterData: CMAccelerometerData!, error: NSError!) in
            let acceleration = acceleromterData.acceleration
            self.xAccel = (CGFloat(acceleration.x) * 0.75) + (self.xAccel * 0.25)
            self.yAccel = (CGFloat(acceleration.y) * 0.75) + (self.yAccel * 0.25)
            })
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
        /*playerNode.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Player
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Asteriod
        */
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
        let r = arc4random() % 6
        var type : AsteriodType
        switch (r) {
        case 0:
            type = .Big
        case 1,2:
            type = .Medium
        default:
            type = .Small
        }
        let node = asteriodNode(type: type)
        let thePosition = CGPoint(x: CGFloat(arc4random()) % width, y: CGFloat(arc4random()) % height)
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
        node.addChild(sprite)
        return node
    }
    func setAsteriodProperties(asteriods: [asteriodNode]){
        let numberOfAsteriods = asteriods.count - 1
        for i in 0...numberOfAsteriods {
            let node = asteriods[i]
            node.physicsBody = SKPhysicsBody(circleOfRadius: 20.0) //the number 20 is a hack
            node.physicsBody?.dynamic = true
            node.physicsBody?.restitution = 0.5
            node.physicsBody?.friction = 0.0
            node.physicsBody?.angularDamping = 0.0
            node.physicsBody?.linearDamping = 0.0
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = CollisionCategoryBitmask.Asteriod
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = CollisionCategoryBitmask.Asteriod
            switch (node.asteriodType){
            case .Big:
                node.physicsBody?.angularVelocity = (CGFloat(arc4random()) % 4) - 2
                node.physicsBody?.velocity = (CGVector(dx: CGFloat(arc4random()) % 20 - 10, dy: CGFloat(arc4random()) % 10 * -1))
            case .Medium:
                node.physicsBody?.angularVelocity = (CGFloat(arc4random()) % 8) - 4
                node.physicsBody?.velocity = (CGVector(dx: CGFloat(arc4random()) % 40 - 20, dy: CGFloat(arc4random()) % 20 * -1))
            default:
                node.physicsBody?.angularVelocity = (CGFloat(arc4random()) % 16) - 8
                node.physicsBody?.velocity = (CGVector(dx: CGFloat(arc4random()) % 80 - 40, dy: CGFloat(arc4random()) % 40 * -1))
            }
            if node.physicsBody?.velocity.dx == 0 {
                node.physicsBody?.velocity.dx = 1
            }
            if node.physicsBody?.velocity.dy == 0 {
                node.physicsBody?.velocity.dy = 1
            }
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let whichNode = (contact.bodyA.node != player) ? contact.bodyA.node : contact.bodyB.node
        let other = whichNode as GameObjectNode
        var nameOne, nameTwo : String
        if ((contact.bodyA.categoryBitMask & 0x01) == 0x01){
            nameOne = "Asteriod"
        } else {
            nameOne = "what?"
        }
        if ((contact.bodyB.categoryBitMask & 0x01) == 0x01){
            nameTwo = "Asteriod"
        } else {
            nameTwo = "what?"
        }
        println("\(nameOne) collides with \(nameTwo)")
        
        //check what collided with what
        if ((contact.bodyA.categoryBitMask == 0x01) & (contact.bodyB.categoryBitMask == 0x01)){
            let asteriodA = contact.bodyA.node as asteriodNode
            let asteriodB = contact.bodyB.node as asteriodNode
            asteriodCollision(asteriodA, asteriodB: asteriodB)
        }
        
        
    }
    override func didSimulatePhysics() {
        player.physicsBody?.velocity = CGVector(dx: xAccel * 400, dy: yAccel * 400)
        if player.position.x < -20.0 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
        } else if (player.position.x > self.size.width + 20.0) {
            player.position = CGPoint (x: -20.0, y:player.position.y)
        }
        if player.position.y < -20.0 {
            player.position = CGPoint(x: player.position.x, y: self.size.height + 20)
        } else if (player.position.y > self.size.height + 20.0) {
            player.position = CGPoint (x: player.position.x, y:-20.0)
        }
    }
    func asteriodCollision(asteriodA: asteriodNode, asteriodB: asteriodNode){
        runAction(asteriodA.asteriodExplosionSound)
    }
}

/*

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
