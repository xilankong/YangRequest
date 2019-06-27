//
//  YangRequestTargetType.swift
//  Pods-YangRequest_Example
//
//  Created by huangyang on 2019/6/27.
//

import Moya

public protocol YangRequestTargetType: TargetType {
    
    var plugins: [PluginType] { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var callbackQueue: DispatchQueue? { get }
    
    var stubBehavior: StubBehavior { get }
    
}

public extension YangRequestTargetType {
    
    var plugins: [PluginType] {
        return []
    }
    
    var timeoutInterval: TimeInterval {
        return 60
    }
    
    var callbackQueue: DispatchQueue? {
        return nil
    }
    
    var stubBehavior: StubBehavior {
        return .never
    }
    
}
