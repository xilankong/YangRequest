//
//  YangNetworkMonitor.swift
//  Pods-YangRequest_Example
//
//  Created by huangyang on 2019/6/27.
//

import Moya
import Alamofire
import YangExtension
import HandyJSON

public struct KLRequestResult<T>: HandyJSON {
    
    public var data: T?
    
    public var code: Int?
    
    public var msg = ""
    
    public init() {}
    
}

public final class YangRequest {
    
    public enum AcceptLanguage: String {
        // 英语
        case en = "en"
    }
    
    private class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
        
        override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            #if DEBUG
            return .disableEvaluation
            #else
            return .performDefaultEvaluation(validateHost: true)
            #endif
        }
        
        init() {
            super.init(policies: [:])
        }
        
    }
    
    private static var httpHeaders: HTTPHeaders = {
        
        let device = YangDevice()
        
        var headers = HTTPHeaders()
        headers["deviceType"]  = "iOS"
        headers["appVersion"]  = device.appVersion
        headers["deviceMode"]  = device.deviceMode
        headers["osVersion"]   = device.systemVersion
        headers["deviceId"]    = device.deviceId
        headers["languageId"]  = languageId.rawValue
        headers["countryId"]   = ""
        headers["accessToken"] = accessToken ?? ""
        
        return headers
        
    }()
    
    public static var accessToken: String? {
        didSet { httpHeaders["accessToken"] = accessToken ?? "" }
    }
    
    public static var languageId = AcceptLanguage.en {
        didSet { httpHeaders["languageId"] = languageId.rawValue }
    }
    
}

extension YangRequest {
    
    static func generateProvider<T: TargetType>(behavior: StubBehavior,
                                                plugins: [PluginType],
                                                timeoutInterval: TimeInterval,
                                                callbackQueue: DispatchQueue?) -> MoyaProvider<T> {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = httpHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = timeoutInterval
        
        let manager = SessionManager(configuration: configuration, serverTrustPolicyManager: CustomServerTrustPoliceManager())
        
        manager.startRequestsImmediately = false
        
        return MoyaProvider<T>(stubClosure: { _ -> StubBehavior in
            return behavior
        }, callbackQueue: callbackQueue, manager: manager, plugins: plugins)
        
    }
    
}
