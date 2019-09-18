//
//  File.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import RMQClient

protocol SubscriberDelegate{
    func onMessage(message: RMQMessage, from queue: RMQQueue)
}

class Subscriber{
    
    var channel: RMQChannel!
    var queues: [RMQQueue]!
    var delegate: SubscriberDelegate?
    
    init(channel: RMQChannel){
        self.queues = [RMQQueue]()
        self.channel = channel
    }
    
    func subscribe(toQueue named: String){
        
        if self.queues.map({$0.name}).contains(named) { return }
        
        let queue = self.channel.queue(named)
        queue.subscribe { (m) in
            self.delegate?.onMessage(message: m, from: queue)
        }
        self.queues.append(queue)
    }
}
