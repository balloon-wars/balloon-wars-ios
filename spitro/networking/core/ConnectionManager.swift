//
//  ConnectionManager.swift
//  spitro
//
//  Created by Bruno Pastre on 31/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import SocketIO

class ConnectionManager: ConnectionService {
    
    static let instance = ConnectionManager()
    
   
    var services: [ConnectionService] = []

    func setupServices() {
        self.services = [
            GameConnectionService.instance,
        ]
        
        for service in services {
            service.setup()
        }
    }
    
    func setup() {
        self.setupServices()
        Connection.connect()
    }
}
