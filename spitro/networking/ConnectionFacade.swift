//
//  ConnectionFacade.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import CoreGraphics

enum NotificationName {
    case joinedGame
    case playerUpdated
}


class ConnectionFacade{
    static let instance = ConnectionFacade()
    
    static let Notifications: [NotificationName: NSNotification.Name]  = [
        NotificationName.joinedGame : NSNotification.Name("joinedGame"),
        .playerUpdated: NSNotification.Name("playerUpdated")
    ]
    
    var connection: Connection!
    var privateId: String!
    var roomId: String?
    
    
    private init() {
        self.privateId = String.random(length: 32)
    }
    
    func join(room named: String){
        self.roomId = named
        self.connection.subscribe(to: named)
        NotificationCenter.default.post(name: ConnectionFacade.Notifications[.joinedGame
            ]!, object:  nil)
        self.connection.unsubscribe(to: "queueing")
    }
    
    func joinGame(){
        self.connection.subscribe(to: Connection.QUEUES.join.rawValue)
        self.connection.publish(message: self.privateId, on: Connection.QUEUES.queueing.rawValue)
    }
    
    
    func updatePlayer(at position: CGPoint, with rotation: CGFloat){
        let update = PlayerUpdate(id: self.privateId, position: position, zRotation: rotation)
        self.connection.publish(message: update.encode(), on: "playerUpdates")
    }
    
    func onPlayerUpdate(_ encodedUpdate: String){
        let update = PlayerUpdate(from: encodedUpdate)
        
        NotificationCenter.default.post(name: ConnectionFacade.Notifications[.playerUpdated]!, object: nil, userInfo: ["updates" : update])
    }
    
    func setupConnection() {
        
        if self.connection == nil {
            self.connection = Connection()
        }
        
        self.connection.setupConnections()
    }}
