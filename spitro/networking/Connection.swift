////
////  Connection.swift
////  spitro
////
////  Created by Bruno Pastre on 18/09/19.
////  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
////
//
//import Foundation
//
//
//class Connection: SubscriberDelegate {
//    
//    enum QUEUES: String {
//        case queueing = "queueing"
//        case join = "join"
//    }
//    
//    
//    var publisher: Publisher?
//    var subscriber: Subscriber?
//    
//    
//    
//    func setupConnections(){
//        self.subscriber = Subscriber()
//        self.publisher = Publisher()
//        self.subscriber?.delegate = self
//    }
//    
//    func publish(message: String, on queue: String){
//        guard let publisher = self.publisher else { return }
//        publisher.publish(message: message, on: queue)
//    }
//    
//    func subscribe(to queue: String){
//        guard let subscriber = self.subscriber else { return }
//        subscriber.subscribe(toQueue: queue)
//    }
//    
//    func unsubscribe(to queue: String){
//        
//        self.subscriber?.unsubscribe(to: queue)
//    }
//    
//    
//    func onMessage(message rmqMessage: ME, from queue: RMQQueue) {
//        // TODO
//    }
//    
//    func closeAll(){
//        for q in self.subscriber?.queues ?? []{
//            q.delete()
//        }
//        
//        self.connection.close()
//    }
//    
//}
