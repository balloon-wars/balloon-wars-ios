//
//  NeedleNode.swift
//  spitro
//
//  Created by Bruno Pastre on 23/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class NeedleNode: SKShapeNode {
    
    var remotePlayerId: String!
    
    init(_ id: String, circleOfRadius: CGFloat){
        super.init()
        self.remotePlayerId = id
        
        let diameter = circleOfRadius * 2
        self.path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter)), transform: nil)
        self.name = self.remotePlayerId
        self.zPosition = 1000
        self.fillColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func updateNeedle(position: CGPoint, scale: Float ) {
        self.position = position
        self.setScale(CGFloat(scale))
    }
}
