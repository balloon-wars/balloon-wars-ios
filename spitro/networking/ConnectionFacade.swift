//
//  ConnectionFacade.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import CoreGraphics



class ConnectionFacade{
    static let instance = ConnectionFacade()
    
    var connection: Connection!
    var privateId: String!
    var roomId: String?
    
    
    private init() {
        self.privateId = String.random(length: 32)
    }
    
    func setupConnection() {
        self.connection = Connection()
        self.connection.setupConnections()
        
    }
    func disconnect(){
       // TODO
    }

    
    func updateDirection(to: Any) {
        self.connection.emit("directionChanged", message: [to])
    }
    
    func updateSpeed(to: Any) {
         self.connection.emit("speedChanged", message: [to])
    }
        
    func getCurrentPlayerId() -> String {
        return self.connection.getSocket().sid
    }
    
}
