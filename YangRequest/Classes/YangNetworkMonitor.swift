//
//  YangNetworkMonitor.swift
//  Pods-YangRequest_Example
//
//  Created by huangyang on 2019/6/27.
//

import Alamofire
import Foundation

public final class YangNetworkMonitor {
    
    public enum State {
        case wwan
        case wifi
        case notReachable
        case unKnown
    }
    
    public static let shared = YangNetworkMonitor()
    
    public static let networkStateDidChangeNotification = Notification.Name(rawValue: "notification.name.kl.network.state.change")
    
    private var _networkState = State.unKnown
    
    private var _isReachable: Bool
    
    private let reachability = NetworkReachabilityManager()
    
    private var isListening = false
    
    private init() {
        _isReachable = reachability?.isReachable ?? false
    }
    
    private func networkState(with status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        
        switch status {
        case .reachable(.ethernetOrWiFi):
            _networkState = .wifi
            _isReachable = true
            
        case .reachable(.wwan):
            _networkState = .wwan
            _isReachable = true
            
        case .notReachable:
            _networkState = .notReachable
            _isReachable = false
            
        case .unknown:
            _networkState = .unKnown
            _isReachable = false
            
        }
        
    }
    
}

public extension YangNetworkMonitor {
    
    var networkState: State {
        
        if let reachability = reachability {
            networkState(with: reachability.networkReachabilityStatus)
        }
        
        return _networkState
        
    }
    
    var isReachable: Bool {
        
        if let reachability = reachability {
            networkState(with: reachability.networkReachabilityStatus)
        }
        
        return _isReachable
        
    }
    
    func startListening() {
        
        guard !isListening else { return }
        
        isListening = reachability?.startListening() ?? false
        
        reachability?.listener = { [weak self] in
            
            self?.networkState(with: $0)
            
            NotificationCenter.default.post(name: YangNetworkMonitor.networkStateDidChangeNotification, object: self?._networkState)
            
        }
        
    }
    
    func stopListening() {
        reachability?.stopListening()
        isListening = false
    }
    
}
