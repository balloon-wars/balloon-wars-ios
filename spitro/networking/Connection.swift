//
//  Connection.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import RMQClient

class Connection: RMQConnectionDelegateLogger, SubscriberDelegate {
    
    enum QUEUES: String {
        case queueing = "queueing"
        case join = "join"
    }
    
    
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
        self.subscriber?.delegate = self
    }
    
    func publish(message: String, on queue: String){
        guard let publisher = self.publisher else { return }
        publisher.publish(message: message, on: queue)
    }
    
    func subscribe(to queue: String){
        guard let subscriber = self.subscriber else { return }
        subscriber.subscribe(toQueue: queue)
    }
    
    func onMessage(message rmqMessage: RMQMessage, from queue: RMQQueue) {
        guard let message = String(data: rmqMessage.body, encoding: .utf8) else { return }
    
        let splitted =  message.components(separatedBy: ":")
    
        
        guard splitted[0] == ConnectionFacade.instance.privateId, splitted.count == 2 else { return }
        
        switch queue.name {
        case QUEUES.join.rawValue:
            ConnectionFacade.instance.join(room: splitted[1])
        default:
            break
        }
    }
    
}
