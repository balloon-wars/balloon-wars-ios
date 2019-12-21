//
//  PlayerNode.swift
//  spitro
//
//  Created by Bruno Pastre on 19/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {

    var gunNode: SKShapeNode!
    var velocity: CGPoint?
    var angularRotation: CGFloat?
    
    init(color: UIColor, size: CGSize = CGSize(width: 200, height: 200)) {
        let texture = SKTexture(image: UIImage(named: "balloon")!)
        
        super.init(texture: texture, color: color, size: size)
        
//        self.physicsBody = SKPhysicsBody(texture: texture, size: self.size)
//        self.physicsBody?.affectedByGravity = false
        
        self.gunNode = SKShapeNode(circleOfRadius: 20)
        self.gunNode.position  = CGPoint(x: 0, y: self.size.height / 2)
        self.gunNode.zPosition = 1000
        self.gunNode.fillColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.addChild(self.gunNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//
//    func update(){
//        let speed: CGFloat = 0.12
//        guard let angular = self.angularRotation else { return }
//        guard let pVelocity = self.velocity else { return }
//
//        if pVelocity.x != 0 && pVelocity.y != 0 && zRotation != angular {
//            self.zRotation = angular
//        }
//
//
//        let newPos = CGPoint(x: self.position.x + (pVelocity.x * speed), y: self.position.y + (pVelocity.y * speed))
//        guard newPos != self.position else { return }
//        self.position = newPos
//    }
    
    func updatePlayer(velocity newVelocity: CGPoint, rotation newRotation: CGFloat){
        
        self.position = newVelocity
        self.zRotation = newRotation
        
//        self.angularRotation = newRotation
//        self.velocity = newVelocity
    }
    
}
