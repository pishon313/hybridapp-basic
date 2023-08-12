//
//  checkNetwork.swift
//  hybridapp-basic
//
//  Created by Sarah Jeong on 2023/07/30.
//

import Foundation
import SystemConfiguration
import Network


class checkNetwork {
    
    static let shared = checkNetwork()
    
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "checkNetwork")
        monitor.start(queue: queue)
    }
}

