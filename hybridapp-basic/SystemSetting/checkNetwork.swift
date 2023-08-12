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
    
    var statusChangeHandler: ((NWPath) -> Void)? {
        didSet {
            monitor.pathUpdateHandler = { [weak self] path in
                self?.statusChangeHandler?(path)
            }
        }
    }
    
    var connectionType: ConnectionType {
        if monitor.currentPath.usesInterfaceType(.wifi) {
            return .wifi
        } else if monitor.currentPath.usesInterfaceType(.cellular) {
            return .cellular
        } else if monitor.currentPath.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return .unknown
        }
    }

    enum ConnectionType {
        case wifi
        case cellular
        case wiredEthernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "checkNetwork")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

