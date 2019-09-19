//
//  RemotePlayer.swift
//  spitro
//
//  Created by Bruno Pastre on 19/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class RemotePlayerNode: PlayerNode {

    var remotePlayerId: String!
    
    init(playerId: String, color: UIColor){
        super.init(color: color)
        self.remotePlayerId = playerId
        self.name = playerId
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
