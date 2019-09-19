//
//  PlayerUpdate.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import CoreGraphics

class PlayerUpdate {
    var id: String!
    var position: CGPoint!
    var zRotation: CGFloat!
    
    func encode() -> String {
        return "\(self.id!):\(position?.x ?? CGFloat.infinity):\(position?.y ?? CGFloat.infinity):\(zRotation ?? CGFloat.infinity)"
    }
    
    init(id: String, position: CGPoint, zRotation: CGFloat){
        self.id = id
        self.position = position
        self.zRotation = zRotation
    }
    
    init(from string: String){
        var splitted = string.components(separatedBy: ":")
        
        self.id = splitted[0]
        self.position = CGPoint.zero
        
        if let x = (splitted[1] as? NSString)?.floatValue {
            self.position.x = CGFloat(x)
        }
        
        if let y = (splitted[2] as? NSString)?.floatValue {
            self.position.y = CGFloat(y)
        }
        
        if let z = (splitted[3] as? NSString)?.floatValue {
            self.zRotation = CGFloat(z)
        }
        
    }
    
}
