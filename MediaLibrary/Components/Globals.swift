//
//  Globals.swift
//  MediaLibrary
//
//  Created by Andriy Zymenko on 3/8/17.
//  Copyright © 2017 Anzim. All rights reserved.
//

import UIKit

typealias Closure = () -> Void

class Global: NSObject  {
    static let singleton = Global()
    
    fileprivate lazy var autoPlayKey = "autoplay"
    fileprivate lazy var userDefaults = UserDefaults.standard
    
    var autoPlay: Bool {
        get {
            let result = userDefaults.object(forKey: autoPlayKey)
            return result as? Bool ?? true
        }
        set (autoPlayValue) {
            userDefaults.setValue(autoPlayValue, forKeyPath: autoPlayKey)
        }
    }
    
    fileprivate var closures = [String: Closure]()
    
    func executeAfter(seconds delay:Double, name: String, closure: @escaping Closure) {
        executeAfter(seconds: delay, name: name, inQueue: DispatchQueue.main,
                     closure: closure)
    }
    
    func executeAfter(seconds delay:Double, name: String, inQueue queue: DispatchQueue, closure: @escaping Closure)
    {
        closures[name] = closure
        queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC))
        {
            _ = self.executeNow(name)
        }
    }
    
    func executeIsInitiated(_ name: String) -> Bool {
        return closures[name] != nil
    }
    
    func cancelExecution(_ name: String) {
        closures[name] = nil
    }
    
    func executeNow(_ name: String) -> Bool {
        if let closure = self.closures[name] {
            self.closures[name] = nil
            closure()
            return true
        }
        return false
    }
    
    func executeNow(_ name: String, inQueue queue: DispatchQueue) -> Bool {
        if let closure = self.closures[name] {
            self.closures[name] = nil
            queue.async {
                closure()
            }
            return true
        }
        return false
    }
    
    
    
    func cancelAllExecutions() {
        closures.removeAll(keepingCapacity: true)
    }
    
}

let global = Global.singleton
