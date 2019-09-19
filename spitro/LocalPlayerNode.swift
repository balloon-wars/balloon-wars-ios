//
//  LocalPlayerNode.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class LocalPlayerNode: SKSpriteNode {

    override var position: CGPoint{
        didSet {
            self.delegatePlayerUpdate()
        }
    }
    
    override var zRotation: CGFloat {
        didSet {
            self.delegatePlayerUpdate()
        }
    }
    
    func delegatePlayerUpdate(){
        ConnectionFacade.instance.updatePlayer(at: self.position, with: self.zRotation)
    }
}
