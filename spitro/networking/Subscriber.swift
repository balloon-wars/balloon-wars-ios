//
//  File.swift
//  spitro
//
//  Created by Bruno Pastre on 17/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class Message {
    
}

protocol SubscriberDelegate{
    func onMessage(message: Message, from queue: Message)
}

class Subscriber{
    
    
    var delegate: SubscriberDelegate?
    
    
    func subscribe(toQueue named: String){
        
        // TODO
    }
    
    
    func unsubscribe(to queue: String){
        // TODO
    }
}
