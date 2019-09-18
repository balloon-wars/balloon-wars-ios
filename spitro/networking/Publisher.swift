//
//  Publisher.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import RMQClient

class Publisher {
    
    var channel: RMQChannel!
    
    init(channel: RMQChannel){
        self.channel = channel
    }
    
    func publish(message: String, on queue: String){
        self.channel.defaultExchange().publish(message.data(using: .utf8)!, routingKey: queue)
        
        print("Sent ", message, "to", queue)
    }
    
}
