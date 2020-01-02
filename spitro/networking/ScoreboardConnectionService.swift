//
//  File.swift
//  spitro
//
//  Created by Bruno Pastre on 31/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class ScoreboardConnectionService: ConnectionService {
    
    static let instance = ScoreboardConnectionService()
    
    func setup() {
        
        let socket = Connection.getSocket()
        
        socket.on(Event.scoreboardUpdate.rawValue) {data, ack in
            self.onScoreboardUpdate(data[0] as! String)
        }
    }
    
    func onScoreboardUpdate(_ json: String) {
        print("Descolei um scoreboard!", json)
    }
    
}
