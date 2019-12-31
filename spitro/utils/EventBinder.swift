//
//  EventBinder.swift
//  spitro
//
//  Created by Bruno Pastre on 31/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

@objc protocol Bindable {
    
    @objc func onEvent()
}

enum Event: String {
    case scoreboardUpdate = "scoreboardUpdate"
//    case directionChanged = "directionChanged"
//    case speedChanged = "speedChanged"
//    case startAttack = "startAttack"
    case gameUpdate = "gameUpdate"
    
    func toNotificationName() -> Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

class EventBinder {
    
    static func bind<T: Bindable>(_ clasz: T, to name: Event) {
        NotificationCenter.default.addObserver(clasz, selector: #selector(clasz.onEvent), name: name.toNotificationName(), object: nil)
    }
    
    static func bind(_ clasz: Any, to name: Event, with callback: Selector) {
        
        NotificationCenter.default.addObserver(clasz, selector: callback, name: name.toNotificationName(), object: nil)
           
       }
    
    static func trigger(event: Event) {
        NotificationCenter.default.post(name: event.toNotificationName(), object: nil)
    }
    
    static func trigger(event: Event, payload: Any) {
        NotificationCenter.default.post(name: event.toNotificationName(), object: nil, userInfo: ["payload" : payload])
    }
}
