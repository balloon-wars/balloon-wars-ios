//
//  ConnectionFacade.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

enum NotificationName {
    case joinedGame
}


class ConnectionFacade{
    static let instance = ConnectionFacade()
    
    static let Notifications: [NotificationName: NSNotification.Name]  = [
        NotificationName.joinedGame : NSNotification.Name("joinedGame")
    ]
    
    var connection: Connection!
    var privateId: String!
    
    var updateReceiver: GameUpdateDelegate?
    
    private init() {
        self.privateId = String.random(length: 32)
    }
    
    func join(room named: String){
        self.connection.subscribe(to: named)
        NotificationCenter.default.post(name: ConnectionFacade.Notifications[.joinedGame
            ]!, object:  nil)
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
    }}
