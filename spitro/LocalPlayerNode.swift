//
//  LocalPlayerNode.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class LocalPlayerNode: PlayerNode {

//    override var position: CGPoint{
//        willSet(to) {
//            if to.distanceTo(self.position) < 1 {
//                self.delegatePlayerUpdate()
//            }
//        }
//    }
//
//    override var zRotation: CGFloat {
//        didSet {
//            self.delegatePlayerUpdate()
//        }
//    }
    var needsUpdate: Bool! = false
    
    func square(_ value: CGFloat?) ->  Double{
        guard let a = value else { return 0}
        return Double(a * a)
    }
    
    
    
    func delegatePlayerUpdate(){
        if !self.needsUpdate { return }
        ConnectionFacade.instance.updatePlayer(at: self.position, with: self.zRotation, with: self.velocity ?? CGPoint.zero)
    }
}

