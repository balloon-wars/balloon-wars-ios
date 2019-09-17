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
    
    private init() {
        
    }
    
    func setupConnection() {
        if self.connection == nil {
            self.connection = Connection()
        }
    }
}
