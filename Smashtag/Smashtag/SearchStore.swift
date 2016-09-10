//
//  SearchStore.swift
//  Smashtag
//
//  Created by Артем on 08/09/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation

// MARK: Search Query Store

struct SearchStore {
    static let defaults = NSUserDefaults.standardUserDefaults()
    static let maxNumberOfRequests = 100
    
    static var requests: [String] {
        return (defaults.objectForKey("key") as? [String]) ?? []
    }
    
    static func addRequest(request: String) {
        var newArray = requests.filter { (requests) -> Bool in
            requests.caseInsensitiveCompare(request) != .OrderedSame
        }
        newArray.insert(request, atIndex: 0)
        while newArray.count > maxNumberOfRequests {
            newArray.removeLast()
        }
        defaults.setObject(newArray, forKey: "key")
    }
    
    static func removeAtIndex(index: Int) {
        var requests = (defaults.objectForKey("key") as? [String]) ?? []
        requests.removeAtIndex(index)
        defaults.setObject(requests, forKey: "key")
    }
}