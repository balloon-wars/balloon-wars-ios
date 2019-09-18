//
//  ConnectionFacade.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class ConnectionFacade{
    static let instance = ConnectionFacade()
    
    var connection: Connection!
    var privateId: String!
    
    var updateReceiver: GameUpdateDelegate?
    
    private init() {
        self.privateId = String.random(length: 32)
    }
    
    func join(room named: String){
        print("Joining room", named)
    }
    
    func joinGame(){
        self.connection.subscribe(to: Connection.QUEUES.join.rawValue)
        self.connection.publish(message: self.privateId, on: Connection.QUEUES.queueing.rawValue)
    }
    
    func setUpdateReceiver(to updateDelegate: GameUpdateDelegate){
        self.updateReceiver = updateDelegate
    }
    
    
    func setupConnection() {
        
        if self.connection == nil {
            self.connection = Connection()
        }
        
        self.connection.setupConnections()
    }
}
