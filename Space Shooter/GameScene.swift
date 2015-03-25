
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
    let kLaserInterval = 0.25
    let kLaserSpeed : CGFloat = 100.0
    var xAccel  : CGFloat = 0.0
    var yAccel : CGFloat = 0.0
    var time1 = 0.0
    //convience properties
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height

    //convenice functions
    func randomCGPoint()->CGPoint{
        return CGPoint(x: CGFloat(arc4random()) % screenWidth, y: CGFloat(arc4random()) % screenHeight)
    }
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        //background
        backgroundColor = SKColor.blackColor()
        physicsWorld.contactDelegate = self
        
        
        
        //foreground
        foregroundNode = SKNode()
        addChild(foregroundNode)

        //add asteriods
        var arrayOfAsteriods = [asteriodNode]()
        for index in 0...19 {
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
            let asteriodA = createAsteriodAtRandomLocationOfType(type)
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


    
    
    func createPlayer()->SKNode {
        let playerNode = SKNode()
        playerNode.position = CGPoint(x: self.size.width/2, y: 80)
        let sprite = SKSpriteNode(imageNamed: "Spaceship")
        sprite.setScale(0.15)
        playerNode.addChild(sprite)
        playerNode.physicsBody?.usesPreciseCollisionDetection = true
        playerNode.physicsBody?.collisionBitMask = 0x00
        playerNode.physicsBody?.categoryBitMask = 0x02
        return playerNode
    }
    
    
    
    
    func createLaser(location: CGPoint)->laserNode{
        let node = laserNode()
        node.position = location
        node.name = "LASER_NODE"
        var sprite : SKSpriteNode = SKSpriteNode(imageNamed: "Laser.png")
        node.addChild(sprite)
        
            
        return node
    }
    
    /* you are here rukesh
    the createAsteriod functions need to be simplified
    currently, they ignore the type and create a random type
    needs -- createAsteriod; createAsteriodofType(type), createAsteriodofTypeAtLocation(location, type) and createAsteriodRandom
*/
    
    func createAsteriodAtLocation(location: CGPoint, ofType type: AsteriodType) -> asteriodNode{
        let node = createAsteriod()
        node.position = location
        node.asteriodType = type
        if type == .Big {
            node.setScale(0.15)
        } else if type == .Medium {
            node.setScale(0.10)
        } else {
            node.setScale(0.05)
        }
        return node
    }
    func createAsteriodAtRandomLocationOfType(type : AsteriodType) -> asteriodNode{
        let thePosition = CGPoint(x: CGFloat(arc4random()) % screenWidth, y: CGFloat(arc4random()) % screenHeight)
        let node = createAsteriodAtLocation(thePosition, ofType: type)
        return node
    }
    
    func createAsteriod() -> asteriodNode {
        let node = asteriodNode(type: .Small)
        node.name = "NODE_ASTERIOD"
        var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "asteriod3.png")
        node.addChild(sprite)
        return node
    }
    func setAsteriodProperties(asteriods: [asteriodNode]){
        let numberOfAsteriods = asteriods.count - 1
        for i in 0...numberOfAsteriods {
            let node = asteriods[i]
            node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0) //the number 20 is a hack
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.categoryBitMask = 0x01
            node.physicsBody?.contactTestBitMask = 0x02
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
    func setLaserProperties(laser: laserNode){
        laser.physicsBody = SKPhysicsBody(circleOfRadius: 20.0) //the number 20 is a hack
        laser.physicsBody?.dynamic = true
        laser.physicsBody?.restitution = 0.5
        laser.physicsBody?.friction = 0.0
        laser.physicsBody?.angularDamping = 0.0
        laser.physicsBody?.linearDamping = 0.0
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.categoryBitMask = 0x02
        laser.physicsBody?.contactTestBitMask = 0x00
        laser.physicsBody?.velocity = (CGVector(dx: 0, dy: kLaserSpeed))
    }
    
    
    
    override func update(currentTime: NSTimeInterval) {
        //first get rid of old lasers
        
        //get rid of defunct asteriods
        foregroundNode.enumerateChildNodesWithName("NODE_ASTERIOD"){
            node, stop in
            if let asteriod = node as? asteriodNode {
            if asteriod.shouldDelete == true {
                node.removeFromParent()
            }
        }
        }
        
        if(time1 == 0) {
            time1 = currentTime
        }
        if (currentTime > time1 + kLaserInterval){
            let laserShot = createLaser(player.position)
            setLaserProperties(laserShot)
            foregroundNode.addChild(laserShot)
            time1 = currentTime
        }
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        let asteriodExplosionSound = SKAction.playSoundFileNamed("Grenade Explosion-SoundBible.com-2100581469.wav", waitForCompletion: false)
        runAction(asteriodExplosionSound)
        if let object = contact.bodyA?.node {
            if object.name == "NODE_ASTERIOD" {
                let asteriod = object as asteriodNode
                asteriod.shouldDelete = true
            } else if let object = contact.bodyB?.node {
                if object.name == "NODE_ASTERIOD" {
                    let asteriod = object as asteriodNode
                    asteriod.shouldDelete = true
                }
            }
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
    func asteriodCollision(asteriodA: asteriodNode, asteriodB: asteriodNode, location: CGPoint){
        asteriodA.removeFromParent()
        return //temporary until I get lasers working
        switch (asteriodB.asteriodType){
        case .Big:
            println("Big")
            /*let location = CGPoint(x: screenWidth/2, y: screenHeight/2)
            let newAsteriodA = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: CGPoint(x: location.x-50, y: location.y-50), ofType: .Medium)
            let newAsteriodB = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: location, ofType: .Medium)
            let arrayOfAsteriods = [newAsteriodA, newAsteriodB]
            setAsteriodProperties(arrayOfAsteriods)
            foregroundNode.addChild(newAsteriodB)
            foregroundNode.addChild(newAsteriodA)
*/

        case .Medium:
           println("Medium")
           let locationA = randomCGPoint()
           let locationB = randomCGPoint()
           /*
           let newAsteriodA = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: locationA, ofType: .Medium)
           let newAsteriodB = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: locationB, ofType: .Medium)
           let arrayOfAsteriods = [newAsteriodA, newAsteriodB]
           setAsteriodProperties(arrayOfAsteriods)
           foregroundNode.addChild(newAsteriodB)
           foregroundNode.addChild(newAsteriodA)
           //you need to make smaller and fewer asteriods
            //and change the asteriodCollision so that it implements laser fire instead of asteriods
            //otherwise there is a proliferation of asteriods.
            */
        default:
            println("Small")
            let locationA = randomCGPoint()
            let locationB = randomCGPoint()
            /*
            let newAsteriodA = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: locationA, ofType: .Medium)
            let newAsteriodB = createAsteriodForScreenSizeAtPoint(screenHeight, width: screenWidth, location: locationB, ofType: .Medium)
            let arrayOfAsteriods = [newAsteriodA, newAsteriodB]
            setAsteriodProperties(arrayOfAsteriods)
            foregroundNode.addChild(newAsteriodB)
            foregroundNode.addChild(newAsteriodA)
*/
        }

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
