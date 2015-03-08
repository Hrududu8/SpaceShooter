//
//  GameObjectNode.swift
//  Space Shooter
//
//  Created by rukesh on 3/5/15.
//  Copyright (c) 2015 Rukesh. All rights reserved.
//

import UIKit
import SpriteKit

enum AsteriodType : Int {
    case Big = 0
    case Medium
    case Small
}

struct CollisionCategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Asteriod: UInt32 = 0x01
    static let Laser: UInt32 = 0x02
}


class GameObjectNode: SKNode {
    let asteriodExplosionSound = SKAction.playSoundFileNamed("Grenade Explosion-SoundBible.com-2100581469.wav", waitForCompletion: false)
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat){
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
    
}

class StarNode : GameObjectNode {
    override func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
}

class asteriodNode: GameObjectNode {
    var asteriodType : AsteriodType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        runAction(asteriodExplosionSound)
        //GAME OVER
        return false
    }
    
    
    
}

