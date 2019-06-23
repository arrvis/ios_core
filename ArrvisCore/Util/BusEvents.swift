//
//  BusEvents.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2019/03/23.
//  Copyright © 2019年 Arrvis Co., Ltd. All rights reserved.
//

// TODO: Rx対応
import Foundation
import SwiftEventBus

/// BusEvent Protocol
public protocol BusEvents {
    var name: String {get}
}

/// システムBusEvent
public enum SystemBusEvents: String, BusEvents {
    case applicationWillEnterForeground
    case applicationDidEnterBackground
    case didReceiveRemoteNotification
    case currentViewControllerChanged

    public var name: String {
        return rawValue
    }
}

extension SwiftEventBus {

    public class func post<T: BusEvents>(_ event: T, sender: Any? = nil) {
        SwiftEventBus.post(event.name, sender: sender)
    }

    public class func post<T: BusEvents>(_ event: T, sender: NSObject?) {
        SwiftEventBus.post(event.name, sender: sender)
    }

    public class func post<T: BusEvents>(_ event: T, sender: Any? = nil, userInfo: [AnyHashable: Any]?) {
        SwiftEventBus.post(event.name, sender: sender, userInfo: userInfo)
    }

    public class func postToMainThread<T: BusEvents>(_ event: T, sender: Any? = nil) {
        SwiftEventBus.postToMainThread(event.name, sender: sender)
    }

    public class func postToMainThread<T: BusEvents>(_ event: T, sender: NSObject?) {
        SwiftEventBus.postToMainThread(event.name, sender: sender)
    }

    public class func postToMainThread<T: BusEvents>(_ event: T, sender: Any? = nil, userInfo: [AnyHashable: Any]?) {
        SwiftEventBus.postToMainThread(event.name, sender: sender, userInfo: userInfo)
    }

    public class func on<T: BusEvents>(_ target: AnyObject,
                                       _ event: T,
                                       sender: Any? = nil,
                                       queue: OperationQueue?,
                                       handler: @escaping ((Notification?) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: event.name, sender: sender, queue: queue, handler: handler)
    }

    public class func onMainThread<T: BusEvents>(_ target: AnyObject,
                                                 _ event: T,
                                                 sender: Any? = nil,
                                                 handler: @escaping ((Notification?) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.onMainThread(target, name: event.name, sender: sender, handler: handler)
    }

    public class func onBackgroundThread<T: BusEvents>(
        _ target: AnyObject,
        _ event: T, sender: Any? = nil,
        handler: @escaping ((Notification?) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.onBackgroundThread(target, name: event.name, sender: sender, handler: handler)
    }
}
