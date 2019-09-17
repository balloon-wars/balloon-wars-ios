//
//  File.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import RMQClient

enum MESSAGES: String, CaseIterable {
    case rotate = "rotate"
    case speed = "speed"
}

protocol SubscriberDelegate {
    
}

class Connection: RMQConnectionDelegateLogger {
    
    var connection: RMQConnection!
    var channel: RMQChannel!
    
    var publisher: Publisher?
    var subscriber: Subscriber?
    
    override init(){
        super.init()
        
        self.connection = RMQConnection(uri: "amqp://jufxdtre:KnXsPM7Zl6KO5it-596PIM0NSaQXuEyJ@crocodile.rmq.cloudamqp.com/jufxdtre", delegate: self)
        self.connection.start()
        self.channel = self.connection.createChannel()
        
        
    }
    
    func setupConnections(){
        self.subscriber = Subscriber(channel: self.channel)
        self.publisher = Publisher(channel: self.channel)
    }

}

class Publisher {
    
    var channel: RMQChannel!
    
    init(channel: RMQChannel){
        self.channel = channel
    }
    
    func publish(message: String, on queue: String){
        
    }
    
}
class Subscriber{
    
    var channel: RMQChannel!
    var queues: [RMQQueue]!
    
    init(channel: RMQChannel){
        self.queues = [RMQQueue]()
        self.channel = channel
    }
    
    func subscribe(toQueue named: String){
        let queue = self.channel.queue(named)
        queue.subscribe { (m) in
            self.onMessage(message: m, from: queue)
        }
        self.queues.append(queue)
    }
    
    func onMessage(message: RMQMessage, from queue: RMQQueue) {
        print("Recebi a mensagem!", String(data: message.body, encoding: .utf8))
        
    }
    
}
