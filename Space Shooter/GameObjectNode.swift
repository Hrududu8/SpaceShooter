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
struct CategoryBitmask {
    static let Player: UInt32 = 0x00
    static let Asteriod: UInt32 = 0x01
    static let Laser: UInt32 = 0x02
}


struct ContactBitmask {
    static let Player: UInt32 = 0x00
    static let Asteriod: UInt32 = 0x04
    static let Laser: UInt32 = 0x01
}


class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat){
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
    func nodeName()->String{
        return "Generic Node -- this should never be"
    }
    
}

class StarNode : GameObjectNode {
    override func collisionWithPlayer(player: SKNode) -> Bool {
        return false
    }
}

class asteriodNode: GameObjectNode {
    var asteriodType : AsteriodType
    
    init(type: AsteriodType){
        asteriodType = type
        super.init()
    }
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        
        //GAME OVER
        return false
    }
    override func nodeName()->String{
        return "AsteriodNode"
    }
}

class laserNode: GameObjectNode{
    override init() {
        super.init()
    }
}







